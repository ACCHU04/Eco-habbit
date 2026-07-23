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
