GRANT USAGE ON SCHEMA public TO tc_admin;
GRANT USAGE ON SCHEMA public TO tc_app;
GRANT USAGE ON SCHEMA public TO tc_readonly;

DO $$
BEGIN
    RAISE NOTICE 'Schemas y permisos configurados correctamente';
END $$;