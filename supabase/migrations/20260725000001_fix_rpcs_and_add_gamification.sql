-- ============================================================
-- Migration: Fix missing RPCs + Add gamification tables
-- ============================================================

-- 1. Fix missing increment_column / decrement_column RPCs
--    Used by community service for like/comment counts

CREATE OR REPLACE FUNCTION increment_column(
  p_table_name TEXT,
  p_column_name TEXT,
  p_row_id UUID
) RETURNS void AS $$
BEGIN
  EXECUTE format(
    'UPDATE %I SET %I = %I + 1 WHERE id = $1',
    p_table_name, p_column_name, p_column_name
  ) USING p_row_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION decrement_column(
  p_table_name TEXT,
  p_column_name TEXT,
  p_row_id UUID
) RETURNS void AS $$
BEGIN
  EXECUTE format(
    'UPDATE %I SET %I = GREATEST(%I - 1, 0) WHERE id = $1',
    p_table_name, p_column_name, p_column_name
  ) USING p_row_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- 2. User XP + Levels
-- ============================================================

CREATE TABLE IF NOT EXISTS user_xp (
  user_id TEXT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  total_xp INTEGER NOT NULL DEFAULT 0,
  level INTEGER NOT NULL DEFAULT 1,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

ALTER TABLE user_xp ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own XP"
  ON user_xp FOR SELECT
  USING (auth.uid()::text = user_id);

CREATE POLICY "System can manage XP"
  ON user_xp FOR ALL
  USING (true);

-- ============================================================
-- 3. Eco Quests
-- ============================================================

CREATE TABLE IF NOT EXISTS eco_quests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  quest_type TEXT NOT NULL CHECK (quest_type IN ('daily', 'weekly', 'challenge')),
  xp_reward INTEGER NOT NULL DEFAULT 0,
  coin_reward INTEGER NOT NULL DEFAULT 0,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard', 'legendary')),
  target_action TEXT NOT NULL,
  target_count INTEGER NOT NULL DEFAULT 1,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

ALTER TABLE eco_quests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read active quests"
  ON eco_quests FOR SELECT
  USING (is_active = true);

-- ============================================================
-- 4. User Quest Progress
-- ============================================================

CREATE TABLE IF NOT EXISTS user_quest_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  quest_id UUID NOT NULL REFERENCES eco_quests(id) ON DELETE CASCADE,
  current_count INTEGER NOT NULL DEFAULT 0,
  completed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  UNIQUE(user_id, quest_id, created_at)
);

ALTER TABLE user_quest_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can read own quest progress"
  ON user_quest_progress FOR SELECT
  USING (auth.uid()::text = user_id);

CREATE POLICY "System can manage quest progress"
  ON user_quest_progress FOR ALL
  USING (true);

-- ============================================================
-- 5. Green Coins extension (add coin_value to eco_rewards)
-- ============================================================

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'eco_rewards' AND column_name = 'coin_value'
  ) THEN
    ALTER TABLE eco_rewards ADD COLUMN coin_value INTEGER DEFAULT 0;
  END IF;
END $$;

-- ============================================================
-- 6. Seed Quests
-- ============================================================

-- Daily quests
INSERT INTO eco_quests (title, description, quest_type, xp_reward, coin_reward, difficulty, target_action, target_count) VALUES
  ('First Scan', 'Scan an item with the AI scanner to earn coins', 'daily', 25, 5, 'easy', 'scan_item', 1),
  ('List an Item', 'Create a marketplace listing for something you no longer need', 'daily', 50, 10, 'easy', 'list_item', 1),
  ('Community Post', 'Share a sustainability tip or eco-friendly idea', 'daily', 30, 5, 'easy', 'create_post', 1)
ON CONFLICT DO NOTHING;

-- Weekly quests
INSERT INTO eco_quests (title, description, quest_type, xp_reward, coin_reward, difficulty, target_action, target_count) VALUES
  ('Sell Three Items', 'Complete 3 marketplace sales this week', 'weekly', 200, 50, 'medium', 'complete_sale', 3),
  ('Recycle Champion', 'Scan and recycle 10 items this week', 'weekly', 300, 75, 'hard', 'recycle_item', 10),
  ('DIY Master', 'Complete 2 DIY projects this week', 'weekly', 250, 60, 'medium', 'complete_diy', 2)
ON CONFLICT DO NOTHING;

-- Challenge quests
INSERT INTO eco_quests (title, description, quest_type, xp_reward, coin_reward, difficulty, target_action, target_count) VALUES
  ('Eco Warrior', 'Complete 50 recycling actions this month', 'challenge', 1000, 250, 'legendary', 'recycle_item', 50),
  ('Marketplace Mogul', 'Sell 20 items this month', 'challenge', 800, 200, 'legendary', 'complete_sale', 20),
  ('Community Leader', 'Get 100 likes on your posts', 'challenge', 500, 100, 'hard', 'receive_likes', 100)
ON CONFLICT DO NOTHING;

-- ============================================================
-- 7. Seed default XP for existing users
-- ============================================================

INSERT INTO user_xp (user_id, total_xp, level)
SELECT id, 0, 1 FROM users
ON CONFLICT (user_id) DO NOTHING;
