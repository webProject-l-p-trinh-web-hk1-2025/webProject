-- Migration script: Add color column to product_images table
-- Date: 2025-10-30
-- Description: Add color field to support multiple product colors

USE cps_db;

-- Add color column to product_images table
ALTER TABLE `product_images` 
ADD COLUMN `color` VARCHAR(100) NULL DEFAULT NULL COMMENT 'Màu sắc của ảnh sản phẩm' 
AFTER `product_id`;

-- Optional: Update existing images with default color (if needed)
-- UPDATE `product_images` SET `color` = 'Mặc định' WHERE `color` IS NULL;

SELECT 'Migration completed successfully!' AS status;
