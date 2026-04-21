UPDATE users
SET created_at = (DATE '2026-02-01' + floor(random() * 2)::int) + interval '8 hours' + (random() * interval '8 hours');
UPDATE users
SET updated_at = created_at + (random() * interval '15 minutes');

UPDATE categories
SET created_at = (DATE '2026-02-03' + floor(random() * 2)::int) + interval '8 hours' + (random() * interval '8 hours');
UPDATE categories
SET updated_at = created_at;

UPDATE products
SET created_at = (DATE '2026-02-05' + floor(random() * 2)::int) + interval '8 hours' + (random() * interval '8 hours');
UPDATE products
SET updated_at = created_at + (random() * interval '45 minutes');

SELECT email, created_at, updated_at FROM users;
SELECT name, created_at, updated_at FROM products;