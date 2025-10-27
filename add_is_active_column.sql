-- Thêm cột is_active vào bảng products
ALTER TABLE products 
ADD COLUMN is_active BOOLEAN DEFAULT TRUE NOT NULL;

-- Đặt tất cả sản phẩm hiện tại là đang kinh doanh
UPDATE products SET is_active = TRUE WHERE is_active IS NULL;
