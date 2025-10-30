-- Migration: Add color column to cart_items table
-- Date: 2025-10-30
-- Purpose: Track selected color for each cart item

ALTER TABLE cart_items 
ADD COLUMN color VARCHAR(100) DEFAULT NULL COMMENT 'Selected color variant for this cart item';

-- Index for querying by color
CREATE INDEX idx_cart_items_color ON cart_items(color);
