DROP TABLE IF EXISTS user_quest_progress CASCADE;

CREATE TABLE user_quest_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  quest_id UUID NOT NULL REFERENCES eco_quests(id) ON DELETE CASCADE,
  current_count INTEGER NOT NULL DEFAULT 0,
  completed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(user_id, quest_id, created_at)
);

ALTER TABLE user_quest_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own quest progress" ON user_quest_progress FOR SELECT USING (auth.uid()::text = user_id);

CREATE OR REPLACE FUNCTION increment_column(p_table_name TEXT, p_column_name TEXT, p_row_id UUID)
RETURNS void AS $$
BEGIN
  EXECUTE format('UPDATE %I SET %I = %I + 1 WHERE id = $1', p_table_name, p_column_name, p_column_name) USING p_row_id;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER SET search_path = public;

CREATE OR REPLACE FUNCTION decrement_column(p_table_name TEXT, p_column_name TEXT, p_row_id UUID)
RETURNS void AS $$
BEGIN
  EXECUTE format('UPDATE %I SET %I = GREATEST(%I - 1, 0) WHERE id = $1', p_table_name, p_column_name, p_column_name) USING p_row_id;
END;
$$ LANGUAGE plpgsql SECURITY INVOKER SET search_path = public;

REVOKE EXECUTE ON FUNCTION increment_column(TEXT, TEXT, UUID) FROM anon;

REVOKE EXECUTE ON FUNCTION decrement_column(TEXT, TEXT, UUID) FROM anon;

CREATE OR REPLACE FUNCTION get_trending_posts(result_limit INTEGER DEFAULT 10)
RETURNS TABLE (id UUID, content TEXT, post_type TEXT, author_id TEXT, likes_count INTEGER, comments_count INTEGER, created_at TIMESTAMP, trending_score DOUBLE PRECISION)
AS $$
BEGIN
  RETURN QUERY SELECT p.id, p.content, p.post_type::TEXT, p.author_id, p.likes_count, p.comments_count, p.created_at,
    ((p.likes_count * 2 + p.comments_count)::DOUBLE PRECISION / POWER(EXTRACT(EPOCH FROM (now() - p.created_at)) / 3600 + 2, 1.5)) AS trending_score
  FROM posts p ORDER BY trending_score DESC LIMIT result_limit;
END;
$$ LANGUAGE plpgsql STABLE SET search_path = public;

DROP POLICY IF EXISTS "System can manage quest progress" ON user_quest_progress;
CREATE POLICY "System can manage quest progress" ON user_quest_progress FOR ALL USING (current_setting('request.jwt.claims', true)::json->>'role' = 'service_role');

DROP POLICY IF EXISTS "System can manage XP" ON user_xp;
CREATE POLICY "System can manage XP" ON user_xp FOR ALL USING (current_setting('request.jwt.claims', true)::json->>'role' = 'service_role');

DROP POLICY IF EXISTS "cache_service_role_all" ON ai_scan_cache;
CREATE POLICY "cache_service_role_all" ON ai_scan_cache FOR ALL USING (current_setting('request.jwt.claims', true)::json->>'role' = 'service_role');

DROP POLICY IF EXISTS "rewards_insert_system" ON eco_rewards;
CREATE POLICY "rewards_insert_system" ON eco_rewards FOR INSERT WITH CHECK (current_setting('request.jwt.claims', true)::json->>'role' = 'service_role');

DROP POLICY IF EXISTS "listing_images_seller_all" ON marketplace_listing_images;
CREATE POLICY "listing_images_seller_all" ON marketplace_listing_images FOR ALL USING (current_setting('request.jwt.claims', true)::json->>'role' = 'service_role');

DROP POLICY IF EXISTS "post_images_author_all" ON post_images;
CREATE POLICY "post_images_author_all" ON post_images FOR ALL USING (current_setting('request.jwt.claims', true)::json->>'role' = 'service_role');

DROP POLICY IF EXISTS "badges_insert_system" ON user_badges;
CREATE POLICY "badges_insert_system" ON user_badges FOR INSERT WITH CHECK (current_setting('request.jwt.claims', true)::json->>'role' = 'service_role');

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SET search_path = public;

CREATE OR REPLACE FUNCTION award_points(p_user_id TEXT, p_points INTEGER, p_action TEXT)
RETURNS VOID AS $$
BEGIN
  INSERT INTO eco_rewards (user_id, points, action)
  VALUES (p_user_id, p_points, p_action);
END;
$$ LANGUAGE plpgsql SET search_path = public;

CREATE OR REPLACE FUNCTION award_badge(p_user_id TEXT, p_badge badge_type)
RETURNS VOID AS $$
BEGIN
  INSERT INTO user_badges (user_id, badge_type)
  VALUES (p_user_id, p_badge)
  ON CONFLICT (user_id, badge_type) DO NOTHING;
END;
$$ LANGUAGE plpgsql SET search_path = public;

CREATE OR REPLACE FUNCTION get_user_points(p_user_id TEXT)
RETURNS INTEGER AS $$
DECLARE
  total INTEGER;
BEGIN
  SELECT COALESCE(SUM(points), 0) INTO total
  FROM eco_rewards
  WHERE user_id = p_user_id;
  RETURN total;
END;
$$ LANGUAGE plpgsql SET search_path = public;

CREATE OR REPLACE FUNCTION get_unread_count(p_user_id TEXT)
RETURNS INTEGER AS $$
DECLARE
  cnt INTEGER;
BEGIN
  SELECT COUNT(*) INTO cnt
  FROM notifications
  WHERE user_id = p_user_id AND read_at IS NULL;
  RETURN cnt;
END;
$$ LANGUAGE plpgsql SET search_path = public;
