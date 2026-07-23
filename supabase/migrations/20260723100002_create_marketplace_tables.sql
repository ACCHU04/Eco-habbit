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
