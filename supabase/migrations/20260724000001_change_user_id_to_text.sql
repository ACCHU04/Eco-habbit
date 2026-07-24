-- Migration: Change users.id and all FK references from uuid to text
-- Purpose: Firebase Auth UIDs are alphanumeric strings, not uuid format
-- Step 1: Drop all RLS policies that reference user columns
-- Step 2: Change column types
-- Step 3: Recreate policies with proper type casting
-- Step 4: Recreate foreign keys

-- ===== STEP 1: Drop all RLS policies on affected tables =====
DROP POLICY IF EXISTS "users_insert_own" ON users;
DROP POLICY IF EXISTS "users_read_own" ON users;
DROP POLICY IF EXISTS "users_update_own" ON users;

DROP POLICY IF EXISTS "listings_seller_all" ON marketplace_listings;
DROP POLICY IF EXISTS "listings_public_read" ON marketplace_listings;

DROP POLICY IF EXISTS "listing_images_seller_all" ON marketplace_listing_images;
DROP POLICY IF EXISTS "listing_images_public_read" ON marketplace_listing_images;

DROP POLICY IF EXISTS "scans_insert_own" ON ai_scans;
DROP POLICY IF EXISTS "scans_read_own" ON ai_scans;

DROP POLICY IF EXISTS "diy_saved_insert_own" ON diy_saved;
DROP POLICY IF EXISTS "diy_saved_read_own" ON diy_saved;
DROP POLICY IF EXISTS "diy_saved_delete_own" ON diy_saved;

DROP POLICY IF EXISTS "posts_author_all" ON posts;
DROP POLICY IF EXISTS "posts_public_read" ON posts;

DROP POLICY IF EXISTS "post_comments_author_all" ON post_comments;
DROP POLICY IF EXISTS "post_comments_public_read" ON post_comments;

DROP POLICY IF EXISTS "post_images_author_all" ON post_images;
DROP POLICY IF EXISTS "post_images_public_read" ON post_images;

DROP POLICY IF EXISTS "post_likes_insert_own" ON post_likes;
DROP POLICY IF EXISTS "post_likes_delete_own" ON post_likes;
DROP POLICY IF EXISTS "post_likes_public_read" ON post_likes;

DROP POLICY IF EXISTS "rewards_insert_system" ON eco_rewards;
DROP POLICY IF EXISTS "rewards_read_own" ON eco_rewards;

DROP POLICY IF EXISTS "badges_insert_system" ON user_badges;
DROP POLICY IF EXISTS "badges_read_own" ON user_badges;

DROP POLICY IF EXISTS "notifications_read_own" ON notifications;
DROP POLICY IF EXISTS "notifications_update_own" ON notifications;

DROP POLICY IF EXISTS "notif_prefs_insert_own" ON notification_preferences;
DROP POLICY IF EXISTS "notif_prefs_read_own" ON notification_preferences;
DROP POLICY IF EXISTS "notif_prefs_update_own" ON notification_preferences;

DROP POLICY IF EXISTS "reports_create" ON reports;
DROP POLICY IF EXISTS "reports_read_own" ON reports;

-- ===== STEP 2: Drop all FK constraints referencing users.id =====
ALTER TABLE marketplace_listings DROP CONSTRAINT IF EXISTS marketplace_listings_seller_id_fkey;
ALTER TABLE ai_scans DROP CONSTRAINT IF EXISTS ai_scans_user_id_fkey;
ALTER TABLE diy_saved DROP CONSTRAINT IF EXISTS diy_saved_user_id_fkey;
ALTER TABLE posts DROP CONSTRAINT IF EXISTS posts_author_id_fkey;
ALTER TABLE post_likes DROP CONSTRAINT IF EXISTS post_likes_user_id_fkey;
ALTER TABLE post_comments DROP CONSTRAINT IF EXISTS post_comments_author_id_fkey;
ALTER TABLE reports DROP CONSTRAINT IF EXISTS reports_reporter_id_fkey;
ALTER TABLE reports DROP CONSTRAINT IF EXISTS reports_admin_id_fkey;
ALTER TABLE eco_rewards DROP CONSTRAINT IF EXISTS eco_rewards_user_id_fkey;
ALTER TABLE user_badges DROP CONSTRAINT IF EXISTS user_badges_user_id_fkey;
ALTER TABLE notifications DROP CONSTRAINT IF EXISTS notifications_user_id_fkey;
ALTER TABLE notification_preferences DROP CONSTRAINT IF EXISTS notification_preferences_user_id_fkey;

-- ===== STEP 3: Change column types from uuid to text =====
ALTER TABLE users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE users ALTER COLUMN id TYPE text;
ALTER TABLE users ALTER COLUMN id SET NOT NULL;

ALTER TABLE marketplace_listings ALTER COLUMN seller_id TYPE text;
ALTER TABLE ai_scans ALTER COLUMN user_id TYPE text;
ALTER TABLE diy_saved ALTER COLUMN user_id TYPE text;
ALTER TABLE posts ALTER COLUMN author_id TYPE text;
ALTER TABLE post_likes ALTER COLUMN user_id TYPE text;
ALTER TABLE post_comments ALTER COLUMN author_id TYPE text;
ALTER TABLE reports ALTER COLUMN reporter_id TYPE text;
ALTER TABLE reports ALTER COLUMN admin_id TYPE text;
ALTER TABLE eco_rewards ALTER COLUMN user_id TYPE text;
ALTER TABLE user_badges ALTER COLUMN user_id TYPE text;
ALTER TABLE notifications ALTER COLUMN user_id TYPE text;
ALTER TABLE notification_preferences ALTER COLUMN user_id TYPE text;

-- ===== STEP 4: Recreate foreign key constraints =====
ALTER TABLE marketplace_listings ADD CONSTRAINT marketplace_listings_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES users(id);
ALTER TABLE ai_scans ADD CONSTRAINT ai_scans_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE diy_saved ADD CONSTRAINT diy_saved_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE posts ADD CONSTRAINT posts_author_id_fkey FOREIGN KEY (author_id) REFERENCES users(id);
ALTER TABLE post_likes ADD CONSTRAINT post_likes_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE post_comments ADD CONSTRAINT post_comments_author_id_fkey FOREIGN KEY (author_id) REFERENCES users(id);
ALTER TABLE reports ADD CONSTRAINT reports_reporter_id_fkey FOREIGN KEY (reporter_id) REFERENCES users(id);
ALTER TABLE reports ADD CONSTRAINT reports_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES users(id);
ALTER TABLE eco_rewards ADD CONSTRAINT eco_rewards_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE user_badges ADD CONSTRAINT user_badges_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE notifications ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE notification_preferences ADD CONSTRAINT notification_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);

-- ===== STEP 5: Recreate RLS policies with text type =====
CREATE POLICY "users_insert_own" ON users
  FOR INSERT WITH CHECK ((auth.uid()::text = id));

CREATE POLICY "users_read_own" ON users
  FOR SELECT USING ((auth.uid()::text = id));

CREATE POLICY "users_update_own" ON users
  FOR UPDATE USING ((auth.uid()::text = id));

CREATE POLICY "listings_public_read" ON marketplace_listings
  FOR SELECT USING ((status = 'active'));

CREATE POLICY "listings_seller_all" ON marketplace_listings
  USING ((seller_id = auth.uid()::text));

CREATE POLICY "listing_images_public_read" ON marketplace_listing_images
  FOR SELECT USING (true);

CREATE POLICY "listing_images_seller_all" ON marketplace_listing_images
  USING (true);

CREATE POLICY "scans_insert_own" ON ai_scans
  FOR INSERT WITH CHECK ((user_id = auth.uid()::text));

CREATE POLICY "scans_read_own" ON ai_scans
  FOR SELECT USING ((user_id = auth.uid()::text));

CREATE POLICY "diy_saved_insert_own" ON diy_saved
  FOR INSERT WITH CHECK ((user_id = auth.uid()::text));

CREATE POLICY "diy_saved_read_own" ON diy_saved
  FOR SELECT USING ((user_id = auth.uid()::text));

CREATE POLICY "diy_saved_delete_own" ON diy_saved
  FOR DELETE USING ((user_id = auth.uid()::text));

CREATE POLICY "posts_author_all" ON posts
  USING ((author_id = auth.uid()::text));

CREATE POLICY "posts_public_read" ON posts
  FOR SELECT USING (true);

CREATE POLICY "post_comments_author_all" ON post_comments
  USING ((author_id = auth.uid()::text));

CREATE POLICY "post_comments_public_read" ON post_comments
  FOR SELECT USING (true);

CREATE POLICY "post_images_author_all" ON post_images
  USING (true);

CREATE POLICY "post_images_public_read" ON post_images
  FOR SELECT USING (true);

CREATE POLICY "post_likes_insert_own" ON post_likes
  FOR INSERT WITH CHECK ((user_id = auth.uid()::text));

CREATE POLICY "post_likes_delete_own" ON post_likes
  FOR DELETE USING ((user_id = auth.uid()::text));

CREATE POLICY "post_likes_public_read" ON post_likes
  FOR SELECT USING (true);

CREATE POLICY "rewards_insert_system" ON eco_rewards
  FOR INSERT WITH CHECK (true);

CREATE POLICY "rewards_read_own" ON eco_rewards
  FOR SELECT USING ((user_id = auth.uid()::text));

CREATE POLICY "badges_insert_system" ON user_badges
  FOR INSERT WITH CHECK (true);

CREATE POLICY "badges_read_own" ON user_badges
  FOR SELECT USING ((user_id = auth.uid()::text));

CREATE POLICY "notifications_read_own" ON notifications
  FOR SELECT USING ((user_id = auth.uid()::text));

CREATE POLICY "notifications_update_own" ON notifications
  FOR UPDATE USING ((user_id = auth.uid()::text));

CREATE POLICY "notif_prefs_insert_own" ON notification_preferences
  FOR INSERT WITH CHECK ((user_id = auth.uid()::text));

CREATE POLICY "notif_prefs_read_own" ON notification_preferences
  FOR SELECT USING ((user_id = auth.uid()::text));

CREATE POLICY "notif_prefs_update_own" ON notification_preferences
  FOR UPDATE USING ((user_id = auth.uid()::text));

CREATE POLICY "reports_create" ON reports
  FOR INSERT WITH CHECK ((reporter_id = auth.uid()::text));

CREATE POLICY "reports_read_own" ON reports
  FOR SELECT USING ((reporter_id = auth.uid()::text));

-- ===== STEP 6: Drop the uuid default sequence =====
DROP SEQUENCE IF EXISTS users_id_seq;
