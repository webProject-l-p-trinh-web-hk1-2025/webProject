-- =====================================================
-- SCRIPT TẠO DỮ LIỆU CATEGORIES PHÂN CẤP CHA-CON
-- Danh mục CHA = Hãng (Apple, Samsung, Xiaomi...)
-- Danh mục CON = Dòng sản phẩm (iPhone 17, Galaxy S24...)
-- =====================================================

-- XÓA DỮ LIỆU CŨ (NẾU CẦN)
-- DELETE FROM categories WHERE parent_id IS NOT NULL;
-- DELETE FROM categories WHERE parent_id IS NULL;

-- =====================================================
-- DANH MỤC CHA (HÃNG)
-- =====================================================

INSERT INTO categories (id, name, description, parent_id) VALUES
(1, 'Apple', 'Sản phẩm Apple chính hãng', NULL),
(2, 'Samsung', 'Sản phẩm Samsung chính hãng', NULL),
(3, 'Xiaomi', 'Sản phẩm Xiaomi chính hãng', NULL),
(4, 'OPPO', 'Sản phẩm OPPO chính hãng', NULL),
(5, 'Vivo', 'Sản phẩm Vivo chính hãng', NULL),
(6, 'realme', 'Sản phẩm realme chính hãng', NULL)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- =====================================================
-- DANH MỤC CON - APPLE (parent_id = 1)
-- =====================================================

INSERT INTO categories (id, name, description, parent_id) VALUES
(101, 'iPhone 17', 'Dòng iPhone 17 series', 1),
(102, 'iPhone 17 Pro Max', 'Dòng iPhone 17 Pro Max', 1),
(103, 'iPhone 17 Pro', 'Dòng iPhone 17 Pro', 1),
(104, 'iPhone 16', 'Dòng iPhone 16 series', 1),
(105, 'iPhone 16 Pro Max', 'Dòng iPhone 16 Pro Max', 1),
(106, 'iPhone 16 Pro', 'Dòng iPhone 16 Pro', 1),
(107, 'iPhone 15', 'Dòng iPhone 15 series', 1),
(108, 'iPhone 15 Pro Max', 'Dòng iPhone 15 Pro Max', 1),
(109, 'iPhone 15 Pro', 'Dòng iPhone 15 Pro', 1),
(110, 'iPhone 14', 'Dòng iPhone 14 series', 1),
(111, 'iPhone 13', 'Dòng iPhone 13 series', 1),
(112, 'iPhone SE', 'Dòng iPhone SE', 1)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- =====================================================
-- DANH MỤC CON - SAMSUNG (parent_id = 2)
-- =====================================================

INSERT INTO categories (id, name, description, parent_id) VALUES
(201, 'Galaxy S24 Ultra', 'Dòng Galaxy S24 Ultra', 2),
(202, 'Galaxy S24+', 'Dòng Galaxy S24 Plus', 2),
(203, 'Galaxy S24', 'Dòng Galaxy S24', 2),
(204, 'Galaxy Z Fold 6', 'Dòng Galaxy Z Fold 6', 2),
(205, 'Galaxy Z Flip 6', 'Dòng Galaxy Z Flip 6', 2),
(206, 'Galaxy A55', 'Dòng Galaxy A55', 2),
(207, 'Galaxy A35', 'Dòng Galaxy A35', 2),
(208, 'Galaxy A15', 'Dòng Galaxy A15', 2),
(209, 'Galaxy M55', 'Dòng Galaxy M55', 2),
(210, 'Galaxy M35', 'Dòng Galaxy M35', 2)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- =====================================================
-- DANH MỤC CON - XIAOMI (parent_id = 3)
-- =====================================================

INSERT INTO categories (id, name, description, parent_id) VALUES
(301, 'Xiaomi 14 Ultra', 'Dòng Xiaomi 14 Ultra', 3),
(302, 'Xiaomi 14', 'Dòng Xiaomi 14', 3),
(303, 'Xiaomi 14T Pro', 'Dòng Xiaomi 14T Pro', 3),
(304, 'Xiaomi 14T', 'Dòng Xiaomi 14T', 3),
(305, 'Redmi Note 13 Pro', 'Dòng Redmi Note 13 Pro', 3),
(306, 'Redmi Note 13', 'Dòng Redmi Note 13', 3),
(307, 'Redmi 13', 'Dòng Redmi 13', 3),
(308, 'Redmi A3', 'Dòng Redmi A3', 3),
(309, 'POCO X6 Pro', 'Dòng POCO X6 Pro', 3),
(310, 'POCO M6', 'Dòng POCO M6', 3)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- =====================================================
-- DANH MỤC CON - OPPO (parent_id = 4)
-- =====================================================

INSERT INTO categories (id, name, description, parent_id) VALUES
(401, 'OPPO Find X8 Pro', 'Dòng OPPO Find X8 Pro', 4),
(402, 'OPPO Find X8', 'Dòng OPPO Find X8', 4),
(403, 'OPPO Reno 12 Pro', 'Dòng OPPO Reno 12 Pro', 4),
(404, 'OPPO Reno 12', 'Dòng OPPO Reno 12', 4),
(405, 'OPPO A3 Pro', 'Dòng OPPO A3 Pro', 4),
(406, 'OPPO A3', 'Dòng OPPO A3', 4),
(407, 'OPPO A18', 'Dòng OPPO A18', 4)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- =====================================================
-- DANH MỤC CON - VIVO (parent_id = 5)
-- =====================================================

INSERT INTO categories (id, name, description, parent_id) VALUES
(501, 'Vivo X200 Pro', 'Dòng Vivo X200 Pro', 5),
(502, 'Vivo X200', 'Dòng Vivo X200', 5),
(503, 'Vivo V40', 'Dòng Vivo V40', 5),
(504, 'Vivo Y200 Pro', 'Dòng Vivo Y200 Pro', 5),
(505, 'Vivo Y28', 'Dòng Vivo Y28', 5),
(506, 'Vivo Y18', 'Dòng Vivo Y18', 5)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- =====================================================
-- DANH MỤC CON - REALME (parent_id = 6)
-- =====================================================

INSERT INTO categories (id, name, description, parent_id) VALUES
(601, 'realme GT 7 Pro', 'Dòng realme GT 7 Pro', 6),
(602, 'realme 13 Pro+', 'Dòng realme 13 Pro Plus', 6),
(603, 'realme 13 Pro', 'Dòng realme 13 Pro', 6),
(604, 'realme 13+', 'Dòng realme 13 Plus', 6),
(605, 'realme C65', 'Dòng realme C65', 6),
(606, 'realme C63', 'Dòng realme C63', 6),
(607, 'realme C61', 'Dòng realme C61', 6)
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- =====================================================
-- RESET AUTO_INCREMENT (TÙY CHỌN)
-- =====================================================
-- ALTER TABLE categories AUTO_INCREMENT = 1000;

-- =====================================================
-- XEM KẾT QUẢ
-- =====================================================
-- SELECT * FROM categories WHERE parent_id IS NULL ORDER BY id; -- Xem hãng
-- SELECT * FROM categories WHERE parent_id = 1 ORDER BY id; -- Xem dòng sản phẩm Apple
-- SELECT * FROM categories WHERE parent_id = 2 ORDER BY id; -- Xem dòng sản phẩm Samsung
