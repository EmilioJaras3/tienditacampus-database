-- V016: Tablas obligatorias para Benchmarking y Analytics (Unidad 2)

-- 1. Tabla de Proyectos
CREATE TABLE IF NOT EXISTS "projects" (
    "project_id" SERIAL PRIMARY KEY,
    "project_type" VARCHAR(20) NOT NULL,
    "description" TEXT,
    "db_engine" VARCHAR(20) NOT NULL
);

-- 2. Tabla de Consultas (Queries)
CREATE TABLE IF NOT EXISTS "queries" (
    "query_id" SERIAL PRIMARY KEY,
    "project_id" INTEGER NOT NULL,
    "query_description" TEXT NOT NULL,
    "query_sql" TEXT NOT NULL,
    "target_table" VARCHAR(100),
    "query_type" VARCHAR(30),
    CONSTRAINT "fk_project" FOREIGN KEY ("project_id") REFERENCES "projects"("project_id") ON DELETE CASCADE
);

-- 3. Tabla de Ejecuciones (Performance Metrics)
CREATE TABLE IF NOT EXISTS "executions" (
    "execution_id" BIGSERIAL PRIMARY KEY,
    "project_id" INTEGER NOT NULL,
    "query_id" INTEGER NOT NULL,
    "index_strategy" VARCHAR(20),
    "execution_timestamp" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "execution_time_ms" BIGINT,
    "records_examined" BIGINT,
    "records_returned" BIGINT,
    "dataset_size_rows" BIGINT,
    "dataset_size_mb" NUMERIC(10,2),
    "concurrent_sessions" INTEGER,
    "shared_buffers_hits" BIGINT,
    "shared_buffers_reads" BIGINT,
    CONSTRAINT "fk_execution_project" FOREIGN KEY ("project_id") REFERENCES "projects"("project_id") ON DELETE CASCADE,
    CONSTRAINT "fk_execution_query" FOREIGN KEY ("query_id") REFERENCES "queries"("query_id") ON DELETE CASCADE
);

-- 4. Vista para Exportación Diaria a BigQuery (V_DAILY_EXPORT)
CREATE OR REPLACE VIEW "V_DAILY_EXPORT" AS
SELECT 
    p.project_type,
    p.db_engine,
    q.query_description,
    e.execution_timestamp,
    e.execution_time_ms,
    e.records_examined,
    e.records_returned,
    e.dataset_size_rows,
    e.dataset_size_mb,
    e.index_strategy
FROM "executions" e
JOIN "projects" p ON e.project_id = p.project_id
JOIN "queries" q ON e.query_id = q.query_id;
