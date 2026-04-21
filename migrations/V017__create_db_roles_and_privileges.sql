DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tc_app') THEN
        CREATE ROLE tc_app WITH LOGIN PASSWORD 'tc_app_secure_2026';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tc_readonly') THEN
        CREATE ROLE tc_readonly WITH LOGIN PASSWORD 'tc_readonly_2026';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tc_admin_db') THEN
        CREATE ROLE tc_admin_db WITH LOGIN PASSWORD 'tc_admin_db_2026' CREATEROLE;
    END IF;
END
$$;

GRANT CONNECT ON DATABASE tienditacampus TO tc_app;
GRANT USAGE ON SCHEMA public TO tc_app;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE
    users,
    products,
    sales,
    inventory,
    orders,
    reports,
    weekly_reports
TO tc_app;

GRANT SELECT, INSERT ON TABLE
    audit_logs
TO tc_app;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE
    projects,
    queries,
    executions
TO tc_app;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO tc_app;

GRANT CONNECT ON DATABASE tienditacampus TO tc_readonly;
GRANT USAGE ON SCHEMA public TO tc_readonly;

GRANT SELECT ON TABLE
    users,
    products,
    sales,
    inventory,
    orders,
    reports,
    weekly_reports,
    audit_logs,
    projects,
    queries,
    executions
TO tc_readonly;

GRANT SELECT ON TABLE "V_DAILY_EXPORT" TO tc_readonly;

GRANT ALL PRIVILEGES ON DATABASE tienditacampus TO tc_admin_db;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO tc_admin_db;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO tc_admin_db;

REVOKE ALL ON SCHEMA public FROM PUBLIC;

REVOKE INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public FROM tc_readonly;

REVOKE CREATE ON SCHEMA public FROM tc_app;

REVOKE DELETE, UPDATE ON TABLE audit_logs FROM tc_app;

COMMENT ON ROLE tc_app IS 'Rol de aplicación backend - CRUD controlado sobre tablas de negocio';
COMMENT ON ROLE tc_readonly IS 'Rol de solo lectura - Para reportes, dashboards y BigQuery export';
COMMENT ON ROLE tc_admin_db IS 'Rol administrativo - Migraciones, backups y mantenimiento de esquema';