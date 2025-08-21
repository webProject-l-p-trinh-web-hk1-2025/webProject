CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(255),
    role SMALLINT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    refresh_token TEXT
);

-- Dữ liệu mẫu
INSERT INTO users (email, full_name, password_hash, role, is_active)
VALUES (
    'test@example.com',
    'Test User',
    '$2a$12$T3ztDZ4qOq39rCbtwiY7CeJu2sp2wU6yyLPalK4VgxEPhiv1PM7Vq',
    0,
    TRUE
)
ON CONFLICT (email) DO NOTHING;
