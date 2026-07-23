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
