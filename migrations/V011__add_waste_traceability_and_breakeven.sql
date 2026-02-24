-- ============================================================
-- TienditaCampus - Migración V011: Merma y Punto de Equilibrio
-- ============================================================
-- Agrega campos para trazabilidad de merma (waste_reason,
-- waste_cost) y punto de equilibrio diario (break_even_units,
-- total_waste_cost) según las reglas de negocio vitales.
-- ============================================================

-- ── 1. Tipo ENUM para causalidad de merma ───────────────────
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'waste_reason_type') THEN
        CREATE TYPE waste_reason_type AS ENUM ('expired', 'damaged', 'other');
    END IF;
END
$$;

-- ── 2. Campos en sale_details ────────────────────────────────
ALTER TABLE sale_details
    ADD COLUMN IF NOT EXISTS waste_reason waste_reason_type NULL,
    ADD COLUMN IF NOT EXISTS waste_cost NUMERIC(10,2) NOT NULL DEFAULT 0
        CONSTRAINT chk_waste_cost_non_negative CHECK (waste_cost >= 0);

COMMENT ON COLUMN sale_details.waste_reason IS 'Causalidad de la merma: vencimiento, daño físico u otro';
COMMENT ON COLUMN sale_details.waste_cost IS 'Costo económico real de la merma (quantity_lost * unit_cost)';

-- ── 3. Campos en daily_sales ─────────────────────────────────
ALTER TABLE daily_sales
    ADD COLUMN IF NOT EXISTS break_even_units NUMERIC(10,2) NULL,
    ADD COLUMN IF NOT EXISTS total_waste_cost NUMERIC(10,2) NOT NULL DEFAULT 0
        CONSTRAINT chk_total_waste_cost_non_negative CHECK (total_waste_cost >= 0);

COMMENT ON COLUMN daily_sales.break_even_units IS 'Unidades mínimas necesarias para cubrir inversión del día';
COMMENT ON COLUMN daily_sales.total_waste_cost IS 'Costo económico total de merma del día (suma de waste_cost de detalles)';

-- ── 4. Índices para consultas de reportes de merma ───────────
CREATE INDEX IF NOT EXISTS idx_sale_details_waste_reason ON sale_details(waste_reason)
    WHERE waste_reason IS NOT NULL;
