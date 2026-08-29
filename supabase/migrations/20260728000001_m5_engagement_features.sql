-- ============================================================
-- M5 Migration: Engagement Features
-- Hostels, Friendships, Hostel Battles, Friend Challenges,
-- Enhanced Leaderboards, Expanded Gamification
-- ============================================================

-- 1. Add hostel + department to users
ALTER TABLE users ADD COLUMN IF NOT EXISTS hostel TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS department TEXT;

CREATE INDEX IF NOT EXISTS idx_users_hostel ON users(hostel);
CREATE INDEX IF NOT EXISTS idx_users_department ON users(department);

-- ============================================================
-- 2. Hostels
-- ============================================================

CREATE TABLE IF NOT EXISTS hostels (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  college TEXT NOT NULL,
  total_score INTEGER NOT NULL DEFAULT 0,
  member_count INTEGER NOT NULL DEFAULT 0,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

ALTER TABLE hostels ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read hostels"
  ON hostels FOR SELECT
  USING (true);

CREATE POLICY "System can manage hostels"
  ON hostels FOR ALL
  USING (current_setting('request.jwt.claims', true)::json->>'role' = 'service_role');

-- ============================================================
-- 3. Friendships
-- ============================================================

CREATE TABLE IF NOT EXISTS friendships (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  requester_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  addressee_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'declined')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(requester_id, addressee_id),
  CHECK (requester_id <> addressee_id)
);

ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own friendships"
  ON friendships FOR SELECT
  USING (auth.uid()::text = requester_id OR auth.uid()::text = addressee_id);

CREATE POLICY "Users can insert friend requests"
  ON friendships FOR INSERT
  WITH CHECK (auth.uid()::text = requester_id);

CREATE POLICY "Users can update own friendships"
  ON friendships FOR UPDATE
  USING (auth.uid()::text = addressee_id OR auth.uid()::text = requester_id);

CREATE POLICY "Users can delete own friendships"
  ON friendships FOR DELETE
  USING (auth.uid()::text = requester_id OR auth.uid()::text = addressee_id);

-- ============================================================
-- 4. Hostel Battles
-- ============================================================

CREATE TABLE IF NOT EXISTS hostel_battles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  hosteler_id UUID NOT NULL REFERENCES hostels(id) ON DELETE CASCADE,
  hosteler_challenger UUID NOT NULL REFERENCES hostels(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled')),
  metric TEXT NOT NULL DEFAULT 'total_score' CHECK (metric IN ('total_score', 'recycled_count', 'items_sold', 'posts_count', 'xp_earned')),
  start_score_hosteler INTEGER NOT NULL DEFAULT 0,
  start_score_challenger INTEGER NOT NULL DEFAULT 0,
  end_score_hosteler INTEGER,
  end_score_challenger INTEGER,
  winner_id UUID REFERENCES hostels(id),
  starts_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  ends_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

ALTER TABLE hostel_battles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read battles"
  ON hostel_battles FOR SELECT
  USING (true);

CREATE POLICY "System can manage battles"
  ON hostel_battles FOR ALL
  USING (current_setting('request.jwt.claims', true)::json->>'role' = 'service_role');

-- ============================================================
-- 5. Friend Challenges
-- ============================================================

CREATE TABLE IF NOT EXISTS friend_challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  challenger_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  challengee_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'completed', 'declined')),
  goal_action TEXT NOT NULL,
  goal_count INTEGER NOT NULL DEFAULT 1,
  challenger_progress INTEGER NOT NULL DEFAULT 0,
  challengee_progress INTEGER NOT NULL DEFAULT 0,
  winner_id TEXT REFERENCES users(id),
  xp_reward INTEGER NOT NULL DEFAULT 100,
  coin_reward INTEGER NOT NULL DEFAULT 25,
  starts_at TIMESTAMP WITH TIME ZONE,
  ends_at TIMESTAMP WITH TIME ZONE NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(challenger_id, challengee_id, created_at),
  CHECK (challenger_id <> challengee_id)
);

ALTER TABLE friend_challenges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own challenges"
  ON friend_challenges FOR SELECT
  USING (auth.uid()::text = challenger_id OR auth.uid()::text = challengee_id);

CREATE POLICY "Users can insert challenges"
  ON friend_challenges FOR INSERT
  WITH CHECK (auth.uid()::text = challenger_id);

CREATE POLICY "Users can update own challenges"
  ON friend_challenges FOR UPDATE
  USING (auth.uid()::text = challenger_id OR auth.uid()::text = challengee_id);

CREATE POLICY "System can manage challenges"
  ON friend_challenges FOR ALL
  USING (current_setting('request.jwt.claims', true)::json->>'role' = 'service_role');

-- ============================================================
-- 6. Expanded badge types
-- ============================================================

DROP TYPE IF EXISTS badge_type CASCADE;
CREATE TYPE badge_type AS ENUM (
  'first_sale',
  'recycler',
  'creator',
  'community_star',
  'campus_champion',
  'eco_warrior',
  'streak_7',
  'upcycler',
  'donor',
  'marketplace_expert',
  'challenge_winner',
  'hostel_hero',
  'friend_maker',
  'daily_warrior',
  'green_legend'
);

-- ============================================================
-- 7. User Achievements (milestone tracking)
-- ============================================================

CREATE TABLE IF NOT EXISTS user_achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  achievement_key TEXT NOT NULL,
  current_value INTEGER NOT NULL DEFAULT 0,
  target_value INTEGER NOT NULL,
  completed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(user_id, achievement_key)
);

ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own achievements"
  ON user_achievements FOR SELECT
  USING (auth.uid()::text = user_id);

CREATE POLICY "System can manage achievements"
  ON user_achievements FOR ALL
  USING (current_setting('request.jwt.claims', true)::json->>'role' = 'service_role');

-- ============================================================
-- 8. RPC: Get filtered leaderboard
-- ============================================================

CREATE OR REPLACE FUNCTION get_filtered_leaderboard(
  filter_type TEXT DEFAULT 'campus',
  filter_value TEXT DEFAULT NULL,
  result_limit INTEGER DEFAULT 50
)
RETURNS TABLE (
  user_id TEXT,
  full_name TEXT,
  profile_photo TEXT,
  total_points INTEGER,
  level INTEGER,
  badge_count BIGINT,
  rank BIGINT
)
LANGUAGE plpgsql STABLE
SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  WITH ranked AS (
    SELECT
      u.id AS uid,
      u.full_name AS uname,
      u.profile_photo AS uphoto,
      COALESCE(SUM(r.points), 0)::INTEGER AS pts,
      COALESCE(xp.level, 1) AS lvl,
      (SELECT COUNT(*) FROM user_badges ub WHERE ub.user_id = u.id) AS bc,
      ROW_NUMBER() OVER (ORDER BY COALESCE(SUM(r.points), 0) DESC) AS rnk
    FROM users u
    LEFT JOIN eco_rewards r ON r.user_id = u.id
    LEFT JOIN user_xp xp ON xp.user_id = u.id
    WHERE
      CASE filter_type
        WHEN 'campus' THEN true
        WHEN 'college' THEN u.college = filter_value
        WHEN 'hostel' THEN u.hostel = filter_value
        WHEN 'department' THEN u.department = filter_value
        ELSE true
      END
    GROUP BY u.id, u.full_name, u.profile_photo, xp.level
  )
  SELECT
    ranked.uid AS user_id,
    ranked.uname AS full_name,
    ranked.uphoto AS profile_photo,
    ranked.pts AS total_points,
    ranked.lvl AS level,
    ranked.bc AS badge_count,
    ranked.rnk AS rank
  FROM ranked
  ORDER BY ranked.rnk
  LIMIT result_limit;
END;
$$;

-- ============================================================
-- 9. RPC: Get friend leaderboard
-- ============================================================

CREATE OR REPLACE FUNCTION get_friend_leaderboard(
  p_user_id TEXT,
  result_limit INTEGER DEFAULT 50
)
RETURNS TABLE (
  user_id TEXT,
  full_name TEXT,
  profile_photo TEXT,
  total_points INTEGER,
  level INTEGER,
  rank BIGINT
)
LANGUAGE plpgsql STABLE
SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  WITH friends AS (
    SELECT CASE
      WHEN requester_id = p_user_id THEN addressee_id
      ELSE requester_id
    END AS friend_id
    FROM friendships
    WHERE (requester_id = p_user_id OR addressee_id = p_user_id)
      AND status = 'accepted'
  ),
  friend_plus_me AS (
    SELECT p_user_id AS uid
    UNION
    SELECT friend_id AS uid FROM friends
  ),
  ranked AS (
    SELECT
      u.id AS uid,
      u.full_name AS uname,
      u.profile_photo AS uphoto,
      COALESCE(SUM(r.points), 0)::INTEGER AS pts,
      COALESCE(xp.level, 1) AS lvl,
      ROW_NUMBER() OVER (ORDER BY COALESCE(SUM(r.points), 0) DESC) AS rnk
    FROM users u
    LEFT JOIN eco_rewards r ON r.user_id = u.id
    LEFT JOIN user_xp xp ON xp.user_id = u.id
    WHERE u.id IN (SELECT uid FROM friend_plus_me)
    GROUP BY u.id, u.full_name, u.profile_photo, xp.level
  )
  SELECT
    ranked.uid AS user_id,
    ranked.uname AS full_name,
    ranked.uphoto AS profile_photo,
    ranked.pts AS total_points,
    ranked.lvl AS level,
    ranked.rnk AS rank
  FROM ranked
  ORDER BY ranked.rnk
  LIMIT result_limit;
END;
$$;

-- ============================================================
-- 10. RPC: Get hostel leaderboard
-- ============================================================

CREATE OR REPLACE FUNCTION get_hostel_leaderboard(
  p_college TEXT DEFAULT NULL,
  result_limit INTEGER DEFAULT 50
)
RETURNS TABLE (
  hostel_id UUID,
  hostel_name TEXT,
  total_score INTEGER,
  member_count INTEGER,
  avg_score DOUBLE PRECISION,
  rank BIGINT
)
LANGUAGE plpgsql STABLE
SET search_path = public
AS $$
BEGIN
  RETURN QUERY
  WITH hostel_scores AS (
    SELECT
      h.id AS hid,
      h.name AS hname,
      COALESCE(SUM(r.points), 0)::INTEGER AS hscore,
      COUNT(DISTINCT u.id)::INTEGER AS hmembers
    FROM hostels h
    LEFT JOIN users u ON u.hostel = h.name
    LEFT JOIN eco_rewards r ON r.user_id = u.id
    WHERE (p_college IS NULL OR h.college = p_college)
    GROUP BY h.id, h.name
  ),
  ranked AS (
    SELECT
      hs.hid,
      hs.hname,
      hs.hscore,
      hs.hmembers,
      CASE WHEN hs.hmembers > 0 THEN hs.hscore::DOUBLE PRECISION / hs.hmembers ELSE 0 END AS avg_sc,
      ROW_NUMBER() OVER (ORDER BY hs.hscore DESC) AS rnk
    FROM hostel_scores hs
  )
  SELECT
    ranked.hid AS hostel_id,
    ranked.hname AS hostel_name,
    ranked.hscore AS total_score,
    ranked.hmembers AS member_count,
    ranked.avg_sc AS avg_score,
    ranked.rnk AS rank
  FROM ranked
  ORDER BY ranked.rnk
  LIMIT result_limit;
END;
$$;

-- ============================================================
-- 11. RPC: Get leaderboard by time period
-- ============================================================

CREATE OR REPLACE FUNCTION get_period_leaderboard(
  period TEXT DEFAULT 'weekly',
  filter_type TEXT DEFAULT 'campus',
  filter_value TEXT DEFAULT NULL,
  result_limit INTEGER DEFAULT 50
)
RETURNS TABLE (
  user_id TEXT,
  full_name TEXT,
  profile_photo TEXT,
  total_points INTEGER,
  rank BIGINT
)
LANGUAGE plpgsql STABLE
SET search_path = public
AS $$
DECLARE
  cutoff TIMESTAMP WITH TIME ZONE;
BEGIN
  cutoff := CASE period
    WHEN 'daily' THEN now() - INTERVAL '1 day'
    WHEN 'weekly' THEN now() - INTERVAL '7 days'
    WHEN 'monthly' THEN now() - INTERVAL '30 days'
    ELSE now() - INTERVAL '7 days'
  END;

  RETURN QUERY
  WITH period_rewards AS (
    SELECT r.user_id AS uid, SUM(r.points)::INTEGER AS pts
    FROM eco_rewards r
    WHERE r.created_at >= cutoff
    GROUP BY r.user_id
  ),
  ranked AS (
    SELECT
      u.id AS uid,
      u.full_name AS uname,
      u.profile_photo AS uphoto,
      COALESCE(pr.pts, 0) AS pts,
      ROW_NUMBER() OVER (ORDER BY COALESCE(pr.pts, 0) DESC) AS rnk
    FROM users u
    LEFT JOIN period_rewards pr ON pr.uid = u.id
    WHERE
      CASE filter_type
        WHEN 'campus' THEN true
        WHEN 'college' THEN u.college = filter_value
        WHEN 'hostel' THEN u.hostel = filter_value
        WHEN 'department' THEN u.department = filter_value
        ELSE true
      END
    GROUP BY u.id, u.full_name, u.profile_photo, pr.pts
  )
  SELECT
    ranked.uid AS user_id,
    ranked.uname AS full_name,
    ranked.uphoto AS profile_photo,
    ranked.pts AS total_points,
    ranked.rnk AS rank
  FROM ranked
  WHERE ranked.pts > 0
  ORDER BY ranked.rnk
  LIMIT result_limit;
END;
$$;

-- ============================================================
-- 12. Trigger: Update hostel member_count on user change
-- ============================================================

CREATE OR REPLACE FUNCTION update_hostel_member_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    IF NEW.hostel IS NOT NULL THEN
      UPDATE hostels
      SET member_count = (SELECT COUNT(*) FROM users WHERE hostel = hostels.name)
      WHERE name = NEW.hostel;
    END IF;
    IF OLD.hostel IS NOT NULL AND OLD.hostel IS DISTINCT FROM NEW.hostel THEN
      UPDATE hostels
      SET member_count = (SELECT COUNT(*) FROM users WHERE hostel = hostels.name)
      WHERE name = OLD.hostel;
    END IF;
  ELSIF TG_OP = 'DELETE' THEN
    IF OLD.hostel IS NOT NULL THEN
      UPDATE hostels
      SET member_count = (SELECT COUNT(*) FROM users WHERE hostel = hostels.name)
      WHERE name = OLD.hostel;
    END IF;
  END IF;
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SET search_path = public;

DROP TRIGGER IF EXISTS trigger_update_hostel_count ON users;
CREATE TRIGGER trigger_update_hostel_count
  AFTER INSERT OR UPDATE OF hostel OR DELETE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_hostel_member_count();

-- ============================================================
-- 13. Trigger: Update friendship updated_at
-- ============================================================

DROP TRIGGER IF EXISTS trigger_friendships_updated_at ON friendships;
CREATE TRIGGER trigger_friendships_updated_at
  BEFORE UPDATE ON friendships
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS trigger_challenges_updated_at ON friend_challenges;
CREATE TRIGGER trigger_challenges_updated_at
  BEFORE UPDATE ON friend_challenges
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS trigger_hostels_updated_at ON hostels;
CREATE TRIGGER trigger_hostels_updated_at
  BEFORE UPDATE ON hostels
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();
