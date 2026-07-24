-- EcoHabbit Database Migrations (13 files combined)
-- Run this in Supabase Dashboard → SQL Editor → New Query

-- ============================================================
-- Migration: 20260723100000_create_enums.sql
-- ============================================================

-- EcoHabit: Create all enum types
-- Reference: docs/08_Database_Design.md

CREATE TYPE user_role AS ENUM ('student', 'ngo', 'organization', 'admin');

CREATE TYPE product_category AS ENUM (
    'textbooks_stationery',
    'electronics_gadgets',
    'furniture_decor',
    'clothing_accessories',
    'sports_fitness',
    'others'
);

CREATE TYPE product_condition AS ENUM ('new', 'good', 'fair', 'used');

CREATE TYPE marketplace_listing_status AS ENUM ('active', 'sold', 'removed');

CREATE TYPE transaction_type AS ENUM ('buy', 'sell', 'rent', 'exchange');

CREATE TYPE post_type AS ENUM ('diy', 'tip', 'marketplace');

CREATE TYPE report_reason AS ENUM ('spam', 'inappropriate', 'scam', 'other');

CREATE TYPE report_status AS ENUM ('pending', 'resolved', 'dismissed');

CREATE TYPE badge_type AS ENUM (
    'first_sale',
    'recycler',
    'creator',
    'community_star',
    'campus_champion',
    'eco_warrior'
);

CREATE TYPE notification_type AS ENUM (
    'like_comment',
    'marketplace_inquiry',
    'reward_achievement',
    'community_update'
);

CREATE TYPE waste_category AS ENUM (
    'plastic',
    'paper_cardboard',
    'glass',
    'metal',
    'organic',
    'ewaste',
    'textile',
    'others'
);

CREATE TYPE difficulty_level AS ENUM ('easy', 'medium', 'hard');


-- ============================================================
-- Migration: 20260723100001_create_users_table.sql
-- ============================================================

-- EcoHabit: Create users table
-- Reference: docs/08_Database_Design.md

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    college TEXT NOT NULL,
    profile_photo TEXT,
    role user_role NOT NULL DEFAULT 'student',
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_college ON users(college);


-- ============================================================
-- Migration: 20260723100002_create_marketplace_tables.sql
-- ============================================================

-- EcoHabit: Create marketplace tables
-- Reference: docs/08_Database_Design.md

CREATE TABLE marketplace_listings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    seller_id UUID NOT NULL REFERENCES users(id),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    price NUMERIC NOT NULL CHECK (price >= 0),
    category product_category NOT NULL,
    "condition" product_condition NOT NULL,
    status marketplace_listing_status NOT NULL DEFAULT 'active',
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_listings_seller ON marketplace_listings(seller_id);
CREATE INDEX idx_listings_category ON marketplace_listings(category);
CREATE INDEX idx_listings_status ON marketplace_listings(status);
CREATE INDEX idx_listings_price ON marketplace_listings(price);
CREATE INDEX idx_listings_created ON marketplace_listings(created_at DESC);

CREATE TABLE marketplace_listing_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    listing_id UUID NOT NULL REFERENCES marketplace_listings(id),
    image_url TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_listing_images_listing ON marketplace_listing_images(listing_id);


-- ============================================================
-- Migration: 20260723100003_create_ai_tables.sql
-- ============================================================

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


-- ============================================================
-- Migration: 20260723100004_create_diy_tables.sql
-- ============================================================

-- EcoHabit: Create DIY tables
-- Reference: docs/08_Database_Design.md

CREATE TABLE diy_projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    materials JSONB NOT NULL,
    steps JSONB NOT NULL,
    difficulty difficulty_level NOT NULL,
    estimated_time TEXT NOT NULL,
    estimated_price NUMERIC NOT NULL,
    category TEXT NOT NULL,
    video_url TEXT,
    source_materials JSONB,
    images JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_diy_category ON diy_projects(category);
CREATE INDEX idx_diy_difficulty ON diy_projects(difficulty);

CREATE TABLE diy_saved (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    project_id UUID NOT NULL REFERENCES diy_projects(id),
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    UNIQUE(user_id, project_id)
);

CREATE INDEX idx_diy_saved_user ON diy_saved(user_id);


-- ============================================================
-- Migration: 20260723100005_create_community_tables.sql
-- ============================================================

-- EcoHabit: Create community tables (posts, images, likes, comments)
-- Reference: docs/08_Database_Design.md

CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id UUID NOT NULL REFERENCES users(id),
    post_type post_type NOT NULL,
    content TEXT NOT NULL,
    diy_project_id UUID,
    marketplace_listing_id UUID,
    likes_count INTEGER NOT NULL DEFAULT 0,
    comments_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_posts_author ON posts(author_id);
CREATE INDEX idx_posts_type ON posts(post_type);
CREATE INDEX idx_posts_created ON posts(created_at DESC);

CREATE TABLE post_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL REFERENCES posts(id),
    image_url TEXT NOT NULL
);

CREATE INDEX idx_post_images_post ON post_images(post_id);

CREATE TABLE post_likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL REFERENCES posts(id),
    user_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    UNIQUE(post_id, user_id)
);

CREATE INDEX idx_post_likes_post ON post_likes(post_id);
CREATE INDEX idx_post_likes_user ON post_likes(user_id);

CREATE TABLE post_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL REFERENCES posts(id),
    author_id UUID NOT NULL REFERENCES users(id),
    content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_post_comments_post ON post_comments(post_id);
CREATE INDEX idx_post_comments_author ON post_comments(author_id);


-- ============================================================
-- Migration: 20260723100006_create_reports_table.sql
-- ============================================================

-- EcoHabit: Create reports table
-- Reference: docs/08_Database_Design.md

CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id UUID NOT NULL REFERENCES users(id),
    content_type TEXT NOT NULL,
    content_id UUID NOT NULL,
    reason report_reason NOT NULL,
    description TEXT,
    status report_status NOT NULL DEFAULT 'pending',
    admin_id UUID REFERENCES users(id),
    action_taken TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_reports_status ON reports(status);
CREATE INDEX idx_reports_content ON reports(content_type, content_id);


-- ============================================================
-- Migration: 20260723100007_create_rewards_tables.sql
-- ============================================================

-- EcoHabit: Create rewards tables (eco_rewards, user_badges)
-- Reference: docs/08_Database_Design.md

CREATE TABLE eco_rewards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    points INTEGER NOT NULL,
    action TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_rewards_user ON eco_rewards(user_id);
CREATE INDEX idx_rewards_created ON eco_rewards(created_at DESC);

CREATE TABLE user_badges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    badge_type badge_type NOT NULL,
    earned_at TIMESTAMP NOT NULL DEFAULT now(),
    UNIQUE(user_id, badge_type)
);

CREATE INDEX idx_badges_user ON user_badges(user_id);


-- ============================================================
-- Migration: 20260723100008_create_notifications_tables.sql
-- ============================================================

-- EcoHabit: Create notifications tables
-- Reference: docs/08_Database_Design.md

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    type notification_type NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    data JSONB,
    read_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(read_at);
CREATE INDEX idx_notifications_created ON notifications(created_at DESC);

CREATE TABLE notification_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE REFERENCES users(id),
    like_comment BOOLEAN NOT NULL DEFAULT true,
    marketplace_inquiry BOOLEAN NOT NULL DEFAULT true,
    reward_achievement BOOLEAN NOT NULL DEFAULT true,
    community_update BOOLEAN NOT NULL DEFAULT false,
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);


-- ============================================================
-- Migration: 20260723100009_create_rls_policies.sql
-- ============================================================

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


-- ============================================================
-- Migration: 20260723100010_create_functions.sql
-- ============================================================

-- EcoHabit: Utility functions
-- Reference: docs/08_Database_Design.md

-- Auto-update updated_at on row changes
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER listings_updated_at
    BEFORE UPDATE ON marketplace_listings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER notif_prefs_updated_at
    BEFORE UPDATE ON notification_preferences
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Award points function (called by app logic)
CREATE OR REPLACE FUNCTION award_points(
    p_user_id UUID,
    p_points INTEGER,
    p_action TEXT
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO eco_rewards (user_id, points, action)
    VALUES (p_user_id, p_points, p_action);
END;
$$ LANGUAGE plpgsql;

-- Award badge function (idempotent)
CREATE OR REPLACE FUNCTION award_badge(
    p_user_id UUID,
    p_badge badge_type
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO user_badges (user_id, badge_type)
    VALUES (p_user_id, p_badge)
    ON CONFLICT (user_id, badge_type) DO NOTHING;
END;
$$ LANGUAGE plpgsql;

-- Get user total points
CREATE OR REPLACE FUNCTION get_user_points(p_user_id UUID)
RETURNS INTEGER AS $$
DECLARE
    total INTEGER;
BEGIN
    SELECT COALESCE(SUM(points), 0) INTO total
    FROM eco_rewards
    WHERE user_id = p_user_id;
    RETURN total;
END;
$$ LANGUAGE plpgsql;

-- Get unread notification count
CREATE OR REPLACE FUNCTION get_unread_count(p_user_id UUID)
RETURNS INTEGER AS $$
DECLARE
    cnt INTEGER;
BEGIN
    SELECT COUNT(*) INTO cnt
    FROM notifications
    WHERE user_id = p_user_id AND read_at IS NULL;
    RETURN cnt;
END;
$$ LANGUAGE plpgsql;


-- ============================================================
-- Migration: 20260723110000_seed_diy_projects.sql
-- ============================================================

-- EcoHabit: Seed curated DIY projects
-- Reference: services/ai_service/app/services/diy_suggestions.py

INSERT INTO diy_projects (id, title, description, materials, steps, difficulty, estimated_time, estimated_price, category, video_url, source_materials, images) VALUES

('550e8400-e29b-41d4-a716-446655440001',
 'Plastic Bottle Planter',
 'Turn plastic bottles into hanging planters for your dorm room.',
 '["plastic bottle", "scissors", "rope", "paint"]',
 '["Cut the bottle in half horizontally", "Poke drainage holes in the bottom", "Paint and decorate the outside", "Thread rope through holes for hanging", "Add soil and plant"]',
 'easy',
 '30 minutes',
 150.0,
 'plastic',
 NULL,
 '["plastic"]',
 '[]'),

('550e8400-e29b-41d4-a716-446655440002',
 'Cardboard Bookshelf',
 'Create a sturdy bookshelf from layered cardboard sheets.',
 '["cardboard", "glue", "scissors", "ruler"]',
 '["Measure and cut cardboard panels", "Layer 5-6 sheets for each shelf", "Glue layers together and let dry", "Assemble shelves with vertical supports", "Reinforce joints with extra glue"]',
 'medium',
 '2 hours',
 300.0,
 'paper_cardboard',
 NULL,
 '["paper_cardboard"]',
 '[]'),

('550e8400-e29b-41d4-a716-446655440003',
 'Glass Jar Lantern',
 'Decorate glass jars into beautiful desk lanterns.',
 '["glass jar", "paint", "LED tea light", "ribbons"]',
 '["Clean the glass jar thoroughly", "Paint patterns or frost the outside", "Let paint dry completely", "Wrap ribbons around the rim", "Place LED tea light inside"]',
 'easy',
 '45 minutes',
 200.0,
 'glass',
 NULL,
 '["glass"]',
 '[]'),

('550e8400-e29b-41d4-a716-446655440004',
 'Tin Can Organizer',
 'Upcycle tin cans into desk organizers for pens and stationery.',
 '["tin can", "paint", "fabric", "glue"]',
 '["Clean and dry the tin can", "Remove any labels", "Paint the outside and let dry", "Wrap fabric around the can", "Secure fabric with glue"]',
 'easy',
 '1 hour',
 120.0,
 'metal',
 NULL,
 '["metal"]',
 '[]'),

('550e8400-e29b-41d4-a716-446655440005',
 'T-Shirt Tote Bag',
 'No-sew tote bag made from an old t-shirt.',
 '["old t-shirt", "scissors"]',
 '["Lay the t-shirt flat", "Cut off the sleeves", "Cut the neckline deeper", "Cut 2-inch strips along the bottom", "Tie strips together tightly"]',
 'easy',
 '20 minutes',
 250.0,
 'textile',
 NULL,
 '["textile"]',
 '[]'),

('550e8400-e29b-41d4-a716-446655440006',
 'Newspaper Seed Pots',
 'Biodegradable seed starter pots from newspaper.',
 '["newspaper", "water"]',
 '["Fold newspaper into strips", "Wrap strips around a small cup mold", "Tuck edges to secure", "Remove mold carefully", "Moisten slightly before planting"]',
 'easy',
 '15 minutes',
 50.0,
 'paper_cardboard',
 NULL,
 '["paper_cardboard"]',
 '[]'),

('550e8400-e29b-41d4-a716-446655440007',
 'E-Waste Sculpture',
 'Create artistic sculptures from broken electronics parts.',
 '["old circuit boards", "hot glue", "wire", "base"]',
 '["Collect and sort e-waste components", "Plan your sculpture design", "Attach pieces to base with hot glue", "Connect parts with wire for stability", "Add finishing touches and details"]',
 'hard',
 '4 hours',
 500.0,
 'ewaste',
 NULL,
 '["ewaste"]',
 '[]'),

('550e8400-e29b-41d4-a716-446655440008',
 'Cardboard Laptop Stand',
 'Ergonomic laptop stand made from reinforced cardboard.',
 '["cardboard", "tape", "scissors"]',
 '["Measure your laptop dimensions", "Cut angled support pieces", "Create triangular supports", "Cut flat shelf piece", "Tape and reinforce all joints"]',
 'medium',
 '1.5 hours',
 350.0,
 'paper_cardboard',
 NULL,
 '["paper_cardboard"]',
 '[]');


-- ============================================================
-- Migration: 20260723120000_add_fcm_token.sql
-- ============================================================

-- EcoHabit: Add fcm_token column to users table

ALTER TABLE users ADD COLUMN fcm_token TEXT;

CREATE INDEX idx_users_fcm_token ON users(fcm_token) WHERE fcm_token IS NOT NULL;



