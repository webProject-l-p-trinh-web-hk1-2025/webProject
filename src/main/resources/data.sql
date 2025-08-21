INSERT INTO users (id, full_name, email, password_hash, role, is_active, created_at, updated_at)
VALUES (0, 'kiet', 'videorubik82@gmail.com', '$2a$12$7d5RDRcYVCxxINajw.n9HOwEaIe5dyBtGGbIUfaQVujFy0IuR7Rea', 0, true, now(), now())
    ON CONFLICT DO NOTHING;

INSERT INTO users (id, full_name, email, password_hash, role, is_active, created_at, updated_at)
VALUES (2, 'anh kiet', 'anhkiet@example.com', '$2a$12$7d5RDRcYVCxxINajw.n9HOwEaIe5dyBtGGbIUfaQVujFy0IuR7Rea', 0, true, now(), now())
    ON CONFLICT DO NOTHING;

