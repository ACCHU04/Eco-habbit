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
