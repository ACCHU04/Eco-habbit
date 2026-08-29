-- EcoHabit: Row-Level Security policies
-- Reference: docs/08_Database_Design.md

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE marketplace_listings ENABLE ROW LEVEL SECURITY;
ALTER TABLE marketplace_listing_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE eco_rewards ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE notification_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_scans ENABLE ROW LEVEL SECURITY;
ALTER TABLE diy_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE diy_saved ENABLE ROW LEVEL SECURITY;

-- users
CREATE POLICY users_read_own ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY users_update_own ON users FOR UPDATE USING (auth.uid() = id);
CREATE POLICY users_insert_own ON users FOR INSERT WITH CHECK (auth.uid() = id);

-- marketplace_listings
CREATE POLICY listings_public_read ON marketplace_listings FOR SELECT USING (status = 'active');
CREATE POLICY listings_seller_all ON marketplace_listings FOR ALL USING (seller_id = auth.uid());

-- marketplace_listing_images
CREATE POLICY listing_images_public_read ON marketplace_listing_images FOR SELECT USING (true);
CREATE POLICY listing_images_seller_all ON marketplace_listing_images FOR ALL USING (
    EXISTS (
        SELECT 1 FROM marketplace_listings
        WHERE id = listing_id AND seller_id = auth.uid()
    )
);

-- posts
CREATE POLICY posts_public_read ON posts FOR SELECT USING (true);
CREATE POLICY posts_author_all ON posts FOR ALL USING (author_id = auth.uid());

-- post_images
CREATE POLICY post_images_public_read ON post_images FOR SELECT USING (true);
CREATE POLICY post_images_author_all ON post_images FOR ALL USING (
    EXISTS (
        SELECT 1 FROM posts WHERE id = post_id AND author_id = auth.uid()
    )
);

-- post_likes
CREATE POLICY post_likes_public_read ON post_likes FOR SELECT USING (true);
CREATE POLICY post_likes_insert_own ON post_likes FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY post_likes_delete_own ON post_likes FOR DELETE USING (user_id = auth.uid());

-- post_comments
CREATE POLICY post_comments_public_read ON post_comments FOR SELECT USING (true);
CREATE POLICY post_comments_author_all ON post_comments FOR ALL USING (author_id = auth.uid());

-- reports
CREATE POLICY reports_create ON reports FOR INSERT WITH CHECK (reporter_id = auth.uid());
CREATE POLICY reports_read_own ON reports FOR SELECT USING (reporter_id = auth.uid());

-- eco_rewards
CREATE POLICY rewards_read_own ON eco_rewards FOR SELECT USING (user_id = auth.uid());
CREATE POLICY rewards_insert_system ON eco_rewards FOR INSERT WITH CHECK (true);

-- user_badges
CREATE POLICY badges_read_own ON user_badges FOR SELECT USING (user_id = auth.uid());
CREATE POLICY badges_insert_system ON user_badges FOR INSERT WITH CHECK (true);

-- notifications
CREATE POLICY notifications_read_own ON notifications FOR SELECT USING (user_id = auth.uid());
CREATE POLICY notifications_update_own ON notifications FOR UPDATE USING (user_id = auth.uid());

-- notification_preferences
CREATE POLICY notif_prefs_read_own ON notification_preferences FOR SELECT USING (user_id = auth.uid());
CREATE POLICY notif_prefs_update_own ON notification_preferences FOR UPDATE USING (user_id = auth.uid());
CREATE POLICY notif_prefs_insert_own ON notification_preferences FOR INSERT WITH CHECK (user_id = auth.uid());

-- ai_scans
CREATE POLICY scans_read_own ON ai_scans FOR SELECT USING (user_id = auth.uid());
CREATE POLICY scans_insert_own ON ai_scans FOR INSERT WITH CHECK (user_id = auth.uid());

-- diy_projects
CREATE POLICY diy_public_read ON diy_projects FOR SELECT USING (true);

-- diy_saved
CREATE POLICY diy_saved_read_own ON diy_saved FOR SELECT USING (user_id = auth.uid());
CREATE POLICY diy_saved_insert_own ON diy_saved FOR INSERT WITH CHECK (user_id = auth.uid());
CREATE POLICY diy_saved_delete_own ON diy_saved FOR DELETE USING (user_id = auth.uid());
