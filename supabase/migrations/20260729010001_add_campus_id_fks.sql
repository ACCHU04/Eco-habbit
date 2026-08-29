-- M10: Add campus_id foreign keys to existing tables
-- All FK columns are nullable for backward compatibility.
-- Backfill attempts to match existing `college` text to seeded campus names.

-- Add campus_id + campus_joined_at to users
ALTER TABLE users ADD COLUMN campus_id UUID REFERENCES campuses(id);
ALTER TABLE users ADD COLUMN campus_joined_at TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS idx_users_campus_id ON users(campus_id) WHERE campus_id IS NOT NULL;

-- Add campus_id to hostels
ALTER TABLE hostels ADD COLUMN campus_id UUID REFERENCES campuses(id);

CREATE INDEX IF NOT EXISTS idx_hostels_campus_id ON hostels(campus_id) WHERE campus_id IS NOT NULL;

-- Add campus_id to posts
ALTER TABLE posts ADD COLUMN campus_id UUID REFERENCES campuses(id);

CREATE INDEX IF NOT EXISTS idx_posts_campus_id ON posts(campus_id) WHERE campus_id IS NOT NULL;

-- Add campus_id to marketplace_listings
ALTER TABLE marketplace_listings ADD COLUMN campus_id UUID REFERENCES campuses(id);

CREATE INDEX IF NOT EXISTS idx_listings_campus_id ON marketplace_listings(campus_id) WHERE campus_id IS NOT NULL;

-- Backfill: match existing data by college name / short_name / slug
-- TODO(M10): migrate leaderboard RPCs from college TEXT to campus_id UUID
CREATE OR REPLACE FUNCTION backfill_campus_ids()
RETURNS void AS $$
BEGIN
  UPDATE users u
  SET campus_id = c.id, campus_joined_at = u.created_at
  FROM campuses c
  WHERE LOWER(u.college) = LOWER(c.name)
     OR LOWER(u.college) = LOWER(c.short_name)
     OR LOWER(u.college) LIKE '%' || LOWER(c.slug) || '%';

  UPDATE hostels h
  SET campus_id = c.id
  FROM campuses c
  WHERE LOWER(h.college) = LOWER(c.name)
     OR LOWER(h.college) = LOWER(c.short_name);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

SELECT backfill_campus_ids();
DROP FUNCTION backfill_campus_ids;
