CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(1000) NOT NULL,
    role VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL,
    refresh_token VARCHAR(2000),
    created_at TIMESTAMP NOT NULL
);

INSERT INTO users (id, full_name, phone, password_hash, role, is_active, created_at)
VALUES (0, 'anh kiet', '0889251007',
        '$2a$12$T3ztDZ4qOq39rCbtwiY7CeJu2sp2wU6yyLPalK4VgxEPhiv1PM7Vq',
        'ADMIN', TRUE, NOW());
ON CONFLICT DO NOTHING;
INSERT INTO users (id, full_name, phone, password_hash, role, is_active, created_at)
VALUES (1, 'kiet', '1234567890',
        '$2a$12$T3ztDZ4qOq39rCbtwiY7CeJu2sp2wU6yyLPalK4VgxEPhiv1PM7Vq',
        'ADMIN', TRUE, NOW())
ON CONFLICT DO NOTHING;

INSERT INTO users (id, full_name, phone, password_hash, role, is_active, created_at)
VALUES (2, 'anh kiet', '98898898321',
        '$2a$12$7d5RDRcYVCxxINajw.n9HOwEaIe5dyBtGGbIUfaQVujFy0IuR7Rea',
        'ADMIN', TRUE, NOW())
ON CONFLICT DO NOTHING;

