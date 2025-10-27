-- URGENT FIX: Update all NULL is_active values to TRUE
-- Run this immediately to fix NullPointerException

-- Update all products with is_active = NULL to TRUE
UPDATE products 
SET is_active = TRUE 
WHERE is_active IS NULL;

-- Verify the fix
SELECT 
    COUNT(*) as total_products,
    SUM(CASE WHEN is_active IS NULL THEN 1 ELSE 0 END) as null_count,
    SUM(CASE WHEN is_active = TRUE THEN 1 ELSE 0 END) as active_count,
    SUM(CASE WHEN is_active = FALSE THEN 1 ELSE 0 END) as inactive_count
FROM products;
