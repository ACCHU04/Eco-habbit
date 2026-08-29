-- ============================================================
-- Migration: Add last_active_date to users for streak tracking
-- ============================================================

ALTER TABLE users
  ADD COLUMN IF NOT EXISTS last_active_date DATE;

-- ============================================================
-- Backfill last_active_date from eco_rewards
-- ============================================================

UPDATE users u
SET last_active_date = (
  SELECT DATE(MAX(r.created_at))
  FROM eco_rewards r
  WHERE r.user_id = u.id
)
WHERE u.id IN (
  SELECT DISTINCT user_id FROM eco_rewards
);

-- ============================================================
-- RLS: Users can read own last_active_date
-- (writes handled by backend service logic)
-- ============================================================
