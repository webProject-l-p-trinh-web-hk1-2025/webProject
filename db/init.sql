CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(1000) NOT NULL,
    role VARCHAR(50) NOT NULL,  
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);


-- Dữ liệu mẫu
INSERT INTO users (full_name, phone, password_hash, role, is_active)
VALUES (
    'Test User',
    '0889251007',
    '$2a$12$T3ztDZ4qOq39rCbtwiY7CeJu2sp2wU6yyLPalK4VgxEPhiv1PM7Vq',
    'USER',
    TRUE
)
ON CONFLICT (phone) DO NOTHING;

