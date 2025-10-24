-- Add product variants for iPhone models
-- This script adds multiple storage options for each iPhone model

-- iPhone 13 variants (id=1 is 128GB)
INSERT INTO products (battery, brand, chipset, cpu_specs, created_at, display_features, display_tech, front_camera, image_url, name, nfc_support, os, price, ram, rear_camera, resolution, screen_size, sim_type, stock, storage, category_id)
VALUES 
('3240 mAh', 'Apple', 'A15 Bionic', '6-core 3.23GHz', '2022-09-24 00:00:00.000000', 'HDR10, Dolby Vision', 'Super Retina XDR OLED', '12 MP', '/uploads/products/1_1761113241366.webp', 'iPhone 13', 'C', 'iOS 15', 18990000.00, '4 GB', '12 MP + 12 MP', '2532x1170', '6.1 inches', 'Dual SIM', 30, '256 GB', 2),
('3240 mAh', 'Apple', 'A15 Bionic', '6-core 3.23GHz', '2022-09-24 00:00:00.000000', 'HDR10, Dolby Vision', 'Super Retina XDR OLED', '12 MP', '/uploads/products/1_1761113241366.webp', 'iPhone 13', 'C', 'iOS 15', 20990000.00, '4 GB', '12 MP + 12 MP', '2532x1170', '6.1 inches', 'Dual SIM', 25, '512 GB', 2);

-- iPhone 15 variants (id=8 is 128GB)
INSERT INTO products (battery, brand, chipset, cpu_specs, created_at, display_features, display_tech, front_camera, image_url, name, nfc_support, os, price, ram, rear_camera, resolution, screen_size, sim_type, stock, storage, category_id)
VALUES 
('3349 mAh', 'Apple', 'A16 Bionic', '6-core 3.46GHz', '2023-09-22 00:00:00.000000', 'HDR10, Dolby Vision, 60Hz', 'Super Retina XDR OLED', '12 MP', '/uploads/products/8_1761114227546.webp', 'iPhone 15', 'C', 'iOS 17', 24990000.00, '6 GB', '48 MP + 12 MP', '2556x1179', '6.1 inches', 'Dual SIM + eSIM', 35, '256 GB', 2),
('3349 mAh', 'Apple', 'A16 Bionic', '6-core 3.46GHz', '2023-09-22 00:00:00.000000', 'HDR10, Dolby Vision, 60Hz', 'Super Retina XDR OLED', '12 MP', '/uploads/products/8_1761114227546.webp', 'iPhone 15', 'C', 'iOS 17', 26990000.00, '6 GB', '48 MP + 12 MP', '2556x1179', '6.1 inches', 'Dual SIM + eSIM', 30, '512 GB', 2);

-- iPhone 15 Plus variants (id=9 is 256GB)
INSERT INTO products (battery, brand, chipset, cpu_specs, created_at, display_features, display_tech, front_camera, image_url, name, nfc_support, os, price, ram, rear_camera, resolution, screen_size, sim_type, stock, storage, category_id)
VALUES 
('4383 mAh', 'Apple', 'A16 Bionic', '6-core 3.46GHz', '2023-09-22 00:00:00.000000', 'HDR10, Dolby Vision, 60Hz', 'Super Retina XDR OLED', '12 MP', '/uploads/products/9_1761114322539.webp', 'iPhone 15 Plus', 'C', 'iOS 17', 23990000.00, '6 GB', '48 MP + 12 MP', '2796x1290', '6.7 inches', 'Dual SIM + eSIM', 35, '128 GB', 2),
('4383 mAh', 'Apple', 'A16 Bionic', '6-core 3.46GHz', '2023-09-22 00:00:00.000000', 'HDR10, Dolby Vision, 60Hz', 'Super Retina XDR OLED', '12 MP', '/uploads/products/9_1761114322539.webp', 'iPhone 15 Plus', 'C', 'iOS 17', 27990000.00, '6 GB', '48 MP + 12 MP', '2796x1290', '6.7 inches', 'Dual SIM + eSIM', 25, '512 GB', 2);

-- iPhone 15 Pro variants (id=10 is 256GB)
INSERT INTO products (battery, brand, chipset, cpu_specs, created_at, display_features, display_tech, front_camera, image_url, name, nfc_support, os, price, ram, rear_camera, resolution, screen_size, sim_type, stock, storage, category_id)
VALUES 
('3274 mAh', 'Apple', 'A17 Pro', '6-core 3.78GHz', '2023-09-22 00:00:00.000000', 'HDR10, ProMotion 120Hz', 'Super Retina XDR OLED', '12 MP', '/uploads/products/10_1761114342079.webp', 'iPhone 15 Pro', 'C', 'iOS 17', 26990000.00, '8 GB', '48 MP + 12 MP + 12 MP', '2556x1179', '6.1 inches', 'Dual SIM + eSIM', 30, '128 GB', 2),
('3274 mAh', 'Apple', 'A17 Pro', '6-core 3.78GHz', '2023-09-22 00:00:00.000000', 'HDR10, ProMotion 120Hz', 'Super Retina XDR OLED', '12 MP', '/uploads/products/10_1761114342079.webp', 'iPhone 15 Pro', 'C', 'iOS 17', 30990000.00, '8 GB', '48 MP + 12 MP + 12 MP', '2556x1179', '6.1 inches', 'Dual SIM + eSIM', 20, '512 GB', 2),
('3274 mAh', 'Apple', 'A17 Pro', '6-core 3.78GHz', '2023-09-22 00:00:00.000000', 'HDR10, ProMotion 120Hz', 'Super Retina XDR OLED', '12 MP', '/uploads/products/10_1761114342079.webp', 'iPhone 15 Pro', 'C', 'iOS 17', 34990000.00, '8 GB', '48 MP + 12 MP + 12 MP', '2556x1179', '6.1 inches', 'Dual SIM + eSIM', 15, '1 TB', 2);

-- iPhone 15 Pro Max variants (id=11 is 512GB)
INSERT INTO products (battery, brand, chipset, cpu_specs, created_at, display_features, display_tech, front_camera, image_url, name, nfc_support, os, price, ram, rear_camera, resolution, screen_size, sim_type, stock, storage, category_id)
VALUES 
('4422 mAh', 'Apple', 'A17 Pro', '6-core 3.78GHz', '2023-09-22 00:00:00.000000', 'HDR10, ProMotion 120Hz', 'Super Retina XDR OLED', '12 MP', '/uploads/products/11_1761114358415.webp', 'iPhone 15 Pro Max', 'C', 'iOS 17', 30990000.00, '8 GB', '48 MP + 12 MP + 12 MP + 12 MP', '2796x1290', '6.7 inches', 'Dual SIM + eSIM', 25, '256 GB', 2),
('4422 mAh', 'Apple', 'A17 Pro', '6-core 3.78GHz', '2023-09-22 00:00:00.000000', 'HDR10, ProMotion 120Hz', 'Super Retina XDR OLED', '12 MP', '/uploads/products/11_1761114358415.webp', 'iPhone 15 Pro Max', 'C', 'iOS 17', 36990000.00, '8 GB', '48 MP + 12 MP + 12 MP + 12 MP', '2796x1290', '6.7 inches', 'Dual SIM + eSIM', 18, '1 TB', 2);

-- iPhone 17 variants (id=12 is 256GB)
INSERT INTO products (battery, brand, chipset, cpu_specs, created_at, display_features, display_tech, front_camera, image_url, name, nfc_support, os, price, ram, rear_camera, resolution, screen_size, sim_type, stock, storage, category_id)
VALUES 
('3550 mAh', 'Apple', 'A19 Bionic', '6-core 3.9GHz', '2025-09-10 00:00:00.000000', 'HDR10, ProMotion 120Hz', 'Super Retina XDR OLED', '12 MP', '/uploads/products/12_1761114299464.webp', 'iPhone 17', 'C', 'iOS 19', 23990000.00, '8 GB', '48 MP + 12 MP', '2556x1179', '6.1 inches', 'Dual SIM + eSIM', 40, '128 GB', 2),
('3550 mAh', 'Apple', 'A19 Bionic', '6-core 3.9GHz', '2025-09-10 00:00:00.000000', 'HDR10, ProMotion 120Hz', 'Super Retina XDR OLED', '12 MP', '/uploads/products/12_1761114299464.webp', 'iPhone 17', 'C', 'iOS 19', 27990000.00, '8 GB', '48 MP + 12 MP', '2556x1179', '6.1 inches', 'Dual SIM + eSIM', 30, '512 GB', 2);

-- iPhone 17 Pro Max variants (id=13 is 1TB)
INSERT INTO products (battery, brand, chipset, cpu_specs, created_at, display_features, display_tech, front_camera, image_url, name, nfc_support, os, price, ram, rear_camera, resolution, screen_size, sim_type, stock, storage, category_id)
VALUES 
('4550 mAh', 'Apple', 'A19 Pro', '6-core 4.0GHz', '2025-09-10 00:00:00.000000', 'HDR10, ProMotion 120Hz, Always-On Display', 'Super Retina XDR OLED', '12 MP', '/uploads/products/13_1761289003002.webp', 'iPhone 17 Pro Max', 'C', 'iOS 19', 33990000.00, '12 GB', '48 MP + 48 MP + 12 MP + 12 MP', '2900x1320', '6.9 inches', 'Dual SIM + eSIM', 20, '256 GB', 2),
('4550 mAh', 'Apple', 'A19 Pro', '6-core 4.0GHz', '2025-09-10 00:00:00.000000', 'HDR10, ProMotion 120Hz, Always-On Display', 'Super Retina XDR OLED', '12 MP', '/uploads/products/13_1761289003002.webp', 'iPhone 17 Pro Max', 'C', 'iOS 19', 35990000.00, '12 GB', '48 MP + 48 MP + 12 MP + 12 MP', '2900x1320', '6.9 inches', 'Dual SIM + eSIM', 18, '512 GB', 2);
