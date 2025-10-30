-- Migration: Add color column to order_items table
-- Date: 2025-10-31
-- Purpose: Track selected color for each order item

ALTER TABLE order_items 
ADD COLUMN color VARCHAR(100) DEFAULT NULL COMMENT 'Selected color variant for this order item';

-- Index for querying by color
CREATE INDEX idx_order_items_color ON order_items(color);
