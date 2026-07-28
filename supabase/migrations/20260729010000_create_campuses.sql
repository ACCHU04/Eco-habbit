-- M10: Multi-Campus Support
-- Creates the campuses table with UUID, immutable slug, metadata, and RLS.

-- Create campuses table
CREATE TABLE IF NOT EXISTS campuses (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug        TEXT UNIQUE NOT NULL,
  name        TEXT NOT NULL,
  short_name  TEXT,
  domain      TEXT,
  logo_url    TEXT,
  city        TEXT,
  state       TEXT,
  country     TEXT NOT NULL DEFAULT 'IN',
  is_active   BOOLEAN NOT NULL DEFAULT true,
  settings    JSONB NOT NULL DEFAULT '{
    "leaderboard_enabled": true,
    "marketplace_enabled": true,
    "ai_enabled": true,
    "theme_color": "#10B981"
  }',
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes
CREATE UNIQUE INDEX IF NOT EXISTS idx_campuses_slug ON campuses(slug);
CREATE INDEX IF NOT EXISTS idx_campuses_name ON campuses(name);
CREATE UNIQUE INDEX IF NOT EXISTS idx_campuses_domain ON campuses(domain) WHERE domain IS NOT NULL;

-- RLS
ALTER TABLE campuses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read active campuses" ON campuses
  FOR SELECT USING (is_active = true);

CREATE POLICY "Service role can manage campuses" ON campuses
  USING (auth.role() = 'service_role');

-- updated_at trigger
CREATE TRIGGER campuses_updated_at
  BEFORE UPDATE ON campuses
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Seed demo campuses
INSERT INTO campuses (slug, name, short_name, domain, city, state) VALUES
  ('chanakya-university', 'Chanakya University', 'CU', 'chanakya.edu', 'Bangalore', 'Karnataka'),
  ('ecotech-institute', 'EcoTech Institute', 'ETI', 'ecotech.edu', 'Mumbai', 'Maharashtra'),
  ('green-valley-college', 'Green Valley College', 'GVC', 'greenvalley.edu', 'Delhi', 'Delhi'),
  ('sustainable-uni', 'Sustainable University', 'SU', 'sustain.edu', 'Chennai', 'Tamil Nadu')
ON CONFLICT (slug) DO NOTHING;
