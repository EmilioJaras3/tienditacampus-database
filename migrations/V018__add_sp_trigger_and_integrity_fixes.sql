-- ============================================================
-- TienditaCampus — Migración V018: SP, Triggers y Fixes de Integridad
-- ============================================================
-- Cierra los gaps detectados en la auditoría BDA Fase 1:
--   1. Stored Procedure: sp_close_daily_sale
--   2. Trigger de negocio: trg_validate_sale_quantities
--   3. Columna GENERATED: order_items.subtotal
--   4. Tabla de 2FA: two_factor_codes (alinear DDL con app)
-- ============================================================


-- ═══════════════════════════════════════════════════════════
-- 1. STORED PROCEDURE: sp_close_daily_sale
-- ═══════════════════════════════════════════════════════════
-- Encapsula la lógica de "cierre de caja del día" de forma atómica.
-- A diferencia de hacerlo desde la app, aquí Postgres garantiza
-- consistencia interna sin riesgo de interrupción parcial.
--
-- Qué hace:
--   a) Valida que la venta exista y no esté cerrada
--   b) Recalcula total_waste_cost desde los detalles (source of truth)
--   c) Calcula break_even_units con la fórmula financiera real
--   d) Marca is_closed = true
-- ═══════════════════════════════════════════════════════════

CREATE OR REPLACE PROCEDURE sp_close_daily_sale(p_sale_id UUID)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_waste_cost  NUMERIC(10,2);
    v_total_investment  NUMERIC(10,2);
    v_total_revenue     NUMERIC(10,2);
    v_units_sold        INTEGER;
    v_units_lost        INTEGER;
    v_break_even_units  NUMERIC(10,2);
    v_avg_sale_price    NUMERIC(10,2);
    v_avg_unit_cost     NUMERIC(10,2);
    v_units_prepared    INTEGER;
    v_waste_rate        NUMERIC(10,4);
    v_effective_cost    NUMERIC(10,2);
    v_unit_margin       NUMERIC(10,2);
BEGIN
    -- ── a) Validar existencia y estado ─────────────────────
    IF NOT EXISTS (
        SELECT 1 FROM daily_sales WHERE id = p_sale_id AND is_closed = false
    ) THEN
        RAISE EXCEPTION 'La venta diaria % no existe o ya se encuentra cerrada.', p_sale_id;
    END IF;

    -- ── b) Recalcular total_waste_cost desde detalles ──────
    SELECT COALESCE(SUM(sd.waste_cost), 0)
      INTO v_total_waste_cost
      FROM sale_details sd
     WHERE sd.daily_sale_id = p_sale_id;

    -- ── c) Obtener agregados actuales ──────────────────────
    SELECT total_investment, total_revenue, units_sold, units_lost
      INTO v_total_investment, v_total_revenue, v_units_sold, v_units_lost
      FROM daily_sales
     WHERE id = p_sale_id;

    -- ── d) Calcular punto de equilibrio ────────────────────
    v_break_even_units := NULL;
    v_units_prepared := v_units_sold + v_units_lost;

    IF v_units_sold > 0 AND v_units_prepared > 0 THEN
        v_avg_sale_price := v_total_revenue / v_units_sold;
        v_avg_unit_cost  := v_total_investment / v_units_prepared;
        v_waste_rate     := v_units_lost::NUMERIC / v_units_prepared;
        v_effective_cost := v_avg_unit_cost * (1 + v_waste_rate);
        v_unit_margin    := v_avg_sale_price - v_effective_cost;

        IF v_unit_margin > 0 THEN
            v_break_even_units := ROUND(v_total_investment / v_unit_margin, 2);
        END IF;
    END IF;

    -- ── e) Aplicar cierre atómico ──────────────────────────
    UPDATE daily_sales
       SET is_closed        = true,
           total_waste_cost = v_total_waste_cost,
           break_even_units = v_break_even_units,
           updated_at       = NOW()
     WHERE id = p_sale_id;
END;
$$;

COMMENT ON PROCEDURE sp_close_daily_sale IS
    'Cierra una venta diaria atómicamente: recalcula merma y punto de equilibrio desde los detalles antes de marcar is_closed=true.';


-- ═══════════════════════════════════════════════════════════
-- 2. TRIGGER DE NEGOCIO: Validación de cantidades en sale_details
-- ═══════════════════════════════════════════════════════════
-- Última línea de defensa contra datos inconsistentes.
-- Impide que vendido + mermado > preparado a nivel BD,
-- independiente del frontend o backend.
-- ═══════════════════════════════════════════════════════════

CREATE OR REPLACE FUNCTION fn_validate_sale_quantities()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF (NEW.quantity_sold + NEW.quantity_lost) > NEW.quantity_prepared THEN
        RAISE EXCEPTION
            'Inconsistencia de inventario: Vendidos (%) + Mermas (%) supera lo preparado (%)',
            NEW.quantity_sold, NEW.quantity_lost, NEW.quantity_prepared;
    END IF;
    RETURN NEW;
END;
$$;

-- Solo crear si no existe (idempotente)
DROP TRIGGER IF EXISTS trg_validate_sale_quantities ON sale_details;
CREATE TRIGGER trg_validate_sale_quantities
    BEFORE INSERT OR UPDATE ON sale_details
    FOR EACH ROW EXECUTE FUNCTION fn_validate_sale_quantities();

COMMENT ON FUNCTION fn_validate_sale_quantities IS
    'Valida que quantity_sold + quantity_lost <= quantity_prepared en cada detalle de venta.';


-- ═══════════════════════════════════════════════════════════
-- 3. COLUMNA GENERATED: order_items.subtotal
-- ═══════════════════════════════════════════════════════════
-- Alinea con el patrón usado en sale_details.subtotal.
-- Postgres calcula subtotal = quantity * unit_price automáticamente.
-- ═══════════════════════════════════════════════════════════

-- Paso 1: Eliminar la columna manual existente
ALTER TABLE order_items DROP COLUMN IF EXISTS subtotal;

-- Paso 2: Recrear como columna generada (calculada por el motor)
ALTER TABLE order_items
    ADD COLUMN subtotal DECIMAL(10,2)
    GENERATED ALWAYS AS (quantity * unit_price) STORED;

COMMENT ON COLUMN order_items.subtotal IS
    'Calculado automáticamente por Postgres: quantity × unit_price. No se puede insertar/actualizar manualmente.';


-- ═══════════════════════════════════════════════════════════
-- 4. TABLA 2FA: two_factor_codes (alinear DDL con la app)
-- ═══════════════════════════════════════════════════════════
-- La entidad TypeORM TwoFactorCode mapea a 'two_factor_codes'.
-- Creamos la tabla explícitamente en DDL para que quede versionada
-- y no dependa de TypeORM synchronize.
-- ═══════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS two_factor_codes (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    code_hash   VARCHAR(255) NOT NULL,
    expires_at  TIMESTAMPTZ NOT NULL,
    used        BOOLEAN NOT NULL DEFAULT false,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_2fa_user ON two_factor_codes(user_id);
CREATE INDEX IF NOT EXISTS idx_2fa_expires ON two_factor_codes(expires_at);

COMMENT ON TABLE two_factor_codes IS
    'Códigos 2FA hasheados con expiración de 10 min. Cada código puede usarse una sola vez.';


-- ═══════════════════════════════════════════════════════════
-- 5. FIX: Permisos para nuevos objetos (rol tc_app)
-- ═══════════════════════════════════════════════════════════

DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tc_app') THEN
        -- Dar permisos CRUD en la nueva tabla 2FA
        GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE two_factor_codes TO tc_app;
        -- Dar EXECUTE en el SP
        GRANT EXECUTE ON PROCEDURE sp_close_daily_sale(UUID) TO tc_app;
    END IF;

    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tc_readonly') THEN
        GRANT SELECT ON TABLE two_factor_codes TO tc_readonly;
    END IF;
END
$$;
