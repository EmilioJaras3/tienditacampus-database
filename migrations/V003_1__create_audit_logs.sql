CREATE TABLE IF NOT EXISTS audit_logs (
    id              UUID DEFAULT uuid_generate_v4() PRIMARY KEY,

    action          VARCHAR(100) NOT NULL,
    entity_type     VARCHAR(50),
    entity_id       UUID,
    user_id         UUID,
    level           VARCHAR(20) DEFAULT 'info',
    description     TEXT,
    ip_address      VARCHAR(45),
    created_at      TIMESTAMPTZ DEFAULT NOW(),

    metadata        JSONB DEFAULT '{}'::jsonb
);

CREATE INDEX IF NOT EXISTS idx_audit_action ON audit_logs (action);
CREATE INDEX IF NOT EXISTS idx_audit_user ON audit_logs (user_id);
CREATE INDEX IF NOT EXISTS idx_audit_entity ON audit_logs (entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_audit_created ON audit_logs (created_at DESC);

CREATE INDEX IF NOT EXISTS idx_audit_metadata ON audit_logs USING GIN (metadata);