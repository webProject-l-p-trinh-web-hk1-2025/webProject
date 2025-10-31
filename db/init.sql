CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(1000) NOT NULL,
    email VARCHAR(255) UNIQUE,
    avatar_url VARCHAR(500),
    address VARCHAR(255),
    role VARCHAR(50) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    refresh_token VARCHAR(2000),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    verify_email BOOLEAN NOT NULL DEFAULT FALSE,
    verify_phone BOOLEAN NOT NULL DEFAULT FALSE
);

-- Admin 1
INSERT INTO users (full_name, phone, password_hash, email, avatar_url, address, role, is_active, verify_email, verify_phone)
VALUES ('anh kiet', '0889251007',
        '$2a$12$T3ztDZ4qOq39rCbtwiY7CeJu2sp2wU6yyLPalK4VgxEPhiv1PM7Vq',
        'kiet@example.com',
        'https://example.com/avatar1.png',
        '123 Lê Lợi, Q1, TP.HCM',
        'ADMIN', TRUE, TRUE, TRUE)
ON DUPLICATE KEY UPDATE phone = phone;

-- Admin 2
INSERT INTO users (full_name, phone, password_hash, email, avatar_url, address, role, is_active, verify_email, verify_phone)
VALUES ('kiet', '1234567890',
        '$2a$12$T3ztDZ4qOq39rCbtwiY7CeJu2sp2wU6yyLPalK4VgxEPhiv1PM7Vq',
        'admin2@example.com',
        'https://example.com/avatar2.png',
        '456 Nguyễn Huệ, Q1, TP.HCM',
        'ADMIN', TRUE, TRUE, TRUE)
ON DUPLICATE KEY UPDATE phone = phone;

-- Admin 3
INSERT INTO users (full_name, phone, password_hash, email, avatar_url, address, role, is_active, verify_email, verify_phone)
VALUES ('anh kiet', '98898898321',
        '$2a$12$7d5RDRcYVCxxINajw.n9HOwEaIe5dyBtGGbIUfaQVujFy0IuR7Rea',
        'admin3@example.com',
        'https://example.com/avatar3.png',
        '789 Trần Hưng Đạo, Q5, TP.HCM',
        'SELLER', TRUE, TRUE, TRUE)
ON DUPLICATE KEY UPDATE phone = phone;
