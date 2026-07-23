-- EcoHabit: Create AI scan tables
-- Reference: docs/08_Database_Design.md

CREATE TABLE ai_scans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    image_url TEXT NOT NULL,
    classification waste_category NOT NULL,
    confidence NUMERIC NOT NULL,
    disposal_tips TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_scans_user ON ai_scans(user_id);
CREATE INDEX idx_scans_created ON ai_scans(created_at DESC);

CREATE TABLE ai_scan_cache (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    image_hash TEXT UNIQUE NOT NULL,
    result JSONB NOT NULL,
    expires_at TIMESTAMP NOT NULL
);

CREATE INDEX idx_cache_hash ON ai_scan_cache(image_hash);
CREATE INDEX idx_cache_expires ON ai_scan_cache(expires_at);
