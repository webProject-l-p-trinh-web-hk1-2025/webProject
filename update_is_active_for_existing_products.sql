-- Script để cập nhật is_active cho các sản phẩm đã tồn tại
-- Chạy script này nếu bạn đã có dữ liệu sản phẩm trước khi thêm field is_active

-- Cách 1: Nếu cột chưa tồn tại, thêm cột mới với giá trị mặc định là TRUE
ALTER TABLE products 
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE;

-- Cách 2: Nếu cột đã tồn tại nhưng có giá trị NULL, cập nhật tất cả thành TRUE
UPDATE products 
SET is_active = TRUE 
WHERE is_active IS NULL;

-- Kiểm tra kết quả
SELECT id, name, is_active, stock 
FROM products 
ORDER BY id;
