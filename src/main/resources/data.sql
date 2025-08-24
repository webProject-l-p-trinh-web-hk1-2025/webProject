INSERT INTO users (id, full_name, phone, password_hash, role, is_active, created_at)
VALUES (0, 'kiet', '1234567890',
        '$2a$12$7d5RDRcYVCxxINajw.n9HOwEaIe5dyBtGGbIUfaQVujFy0IuR7Rea',
        'ADMIN', TRUE, NOW())
ON CONFLICT DO NOTHING;

INSERT INTO users (id, full_name, phone, password_hash, role, is_active, created_at)
VALUES (2, 'anh kiet', '98898898321',
        '$2a$12$7d5RDRcYVCxxINajw.n9HOwEaIe5dyBtGGbIUfaQVujFy0IuR7Rea',
        'ADMIN', TRUE, NOW())
ON CONFLICT DO NOTHING;
