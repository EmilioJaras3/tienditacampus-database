-- ============================================================
-- TienditaCampus - Migración V017: Roles, Permisos y Seguridad
-- ============================================================
-- Implementa el proceso de 5 pasos de seguridad de BD:
--   1. Crear todo el esquema
--   2. Identificar objetivos por cada tabla (Propósito)
--   3. Identificar qué usuarios las usan
--   4. Definir Privilegios
--   5. Revocar permisos innecesarios
-- ============================================================

-- ═══════════════════════════════════════════════════════════
-- PASO 1: ESQUEMA (ya creado en V001-V016)
-- El esquema 'public' contiene todas las tablas del sistema.
-- ═══════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════
-- PASO 2: PROPÓSITO DE CADA TABLA
-- ═══════════════════════════════════════════════════════════
-- users           → Autenticación, perfiles y control de acceso
-- products        → Catálogo de productos de vendedores
-- sales           → Registro de transacciones de venta
-- sale_items      → Detalle de productos por venta
-- inventory       → Control de stock y movimientos
-- orders          → Pedidos de compradores
-- order_items     → Detalle de productos por pedido
-- audit_logs      → Bitácora de auditoría (solo lectura)
-- reports         → Reportes semanales automáticos
-- weekly_reports  → Reportes de rendimiento semanal
-- projects        → Proyectos de benchmarking SOA
-- queries         → Consultas para benchmarking
-- executions      → Métricas de ejecución de queries
-- daily_inventory_snapshots → Fotografías diarias del inventario

-- ═══════════════════════════════════════════════════════════
-- PASO 3: IDENTIFICAR QUÉ USUARIOS USAN LAS TABLAS
-- ═══════════════════════════════════════════════════════════
-- tc_app       → Rol de la aplicación backend (CRUD controlado)
-- tc_readonly  → Rol de solo lectura (para reportes, BI, BigQuery)
-- tc_admin_db  → Rol administrativo (migraciones, mantenimiento)

-- ═══════════════════════════════════════════════════════════
-- PASO 4: DEFINIR PRIVILEGIOS (Crear roles y otorgar permisos)
-- ═══════════════════════════════════════════════════════════

-- ── 4.1 Crear roles si no existen ─────────────────────────
DO $$
BEGIN
    -- Rol de aplicación: el backend se conecta con este usuario
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tc_app') THEN
        CREATE ROLE tc_app WITH LOGIN PASSWORD 'tc_app_secure_2026';
    END IF;

    -- Rol de solo lectura: para dashboards, BigQuery exports, reportes
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tc_readonly') THEN
        CREATE ROLE tc_readonly WITH LOGIN PASSWORD 'tc_readonly_2026';
    END IF;

    -- Rol administrativo: para migraciones y mantenimiento
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tc_admin_db') THEN
        CREATE ROLE tc_admin_db WITH LOGIN PASSWORD 'tc_admin_db_2026' CREATEROLE;
    END IF;
END
$$;

-- ── 4.2 Permisos del rol tc_app (Backend Application) ─────
-- Puede hacer CRUD en las tablas de negocio
GRANT CONNECT ON DATABASE tienditacampus TO tc_app;
GRANT USAGE ON SCHEMA public TO tc_app;

-- Tablas de negocio: SELECT, INSERT, UPDATE, DELETE
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE
    users,
    products,
    daily_sales,
    sale_details,
    inventory_records,
    daily_inventory_snapshots,
    orders,
    order_items,
    weekly_reports
TO tc_app;

-- Tablas auxiliares: el backend solo lee/inserta
GRANT SELECT, INSERT ON TABLE
    audit_logs
TO tc_app;

-- Tablas de benchmarking: CRUD completo
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE
    projects,
    queries,
    executions
TO tc_app;

-- Secuencias (para INSERT con IDs auto-incrementales)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO tc_app;

-- ── 4.3 Permisos del rol tc_readonly (Reportes / BI) ──────
-- Solo puede leer datos, jamás modificar
GRANT CONNECT ON DATABASE tienditacampus TO tc_readonly;
GRANT USAGE ON SCHEMA public TO tc_readonly;

GRANT SELECT ON TABLE
    users,
    products,
    daily_sales,
    sale_details,
    inventory_records,
    daily_inventory_snapshots,
    orders,
    order_items,
    weekly_reports,
    audit_logs,
    projects,
    queries,
    executions
TO tc_readonly;

-- Vistas de exportación
GRANT SELECT ON TABLE "V_DAILY_EXPORT" TO tc_readonly;

-- ── 4.4 Permisos del rol tc_admin_db (Migraciones) ────────
-- Acceso total para administración de esquema
GRANT ALL PRIVILEGES ON DATABASE tienditacampus TO tc_admin_db;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO tc_admin_db;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO tc_admin_db;

-- ═══════════════════════════════════════════════════════════
-- PASO 5: REVOCAR PERMISOS INNECESARIOS
-- ═══════════════════════════════════════════════════════════

-- Revocar acceso público al esquema (buena práctica de seguridad)
REVOKE ALL ON SCHEMA public FROM PUBLIC;

-- El rol tc_readonly NO puede modificar datos
REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM tc_readonly;

-- El rol tc_app NO puede crear/eliminar tablas
REVOKE CREATE ON SCHEMA public FROM tc_app;

-- El rol tc_app NO puede borrar la tabla de auditoría
REVOKE DELETE, UPDATE ON TABLE audit_logs FROM tc_app;

-- ── Comentarios de documentación ──────────────────────────
COMMENT ON ROLE tc_app IS 'Rol de aplicación backend - CRUD controlado sobre tablas de negocio';
COMMENT ON ROLE tc_readonly IS 'Rol de solo lectura - Para reportes, dashboards y BigQuery export';
COMMENT ON ROLE tc_admin_db IS 'Rol administrativo - Migraciones, backups y mantenimiento de esquema';
