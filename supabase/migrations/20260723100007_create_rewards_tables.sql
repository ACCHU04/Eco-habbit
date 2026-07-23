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
