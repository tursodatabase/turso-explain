-- Demo schema for the example plans. Small but shaped so the optimizer
-- shows off: indexed + unindexed joins, a computed join key that forces
-- hash joins, and enough rows for ANALYZE to matter.
CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, age INTEGER, city_id INTEGER);
CREATE TABLE cities (id INTEGER PRIMARY KEY, name TEXT);
CREATE TABLE orders (id INTEGER PRIMARY KEY, user_id INTEGER, amount REAL);
CREATE TABLE sessions (id INTEGER PRIMARY KEY, session_key TEXT, device TEXT);
CREATE TABLE events (id INTEGER PRIMARY KEY, session_key TEXT, kind TEXT);
CREATE INDEX idx_users_age ON users(age);
CREATE INDEX idx_orders_user ON orders(user_id);

INSERT INTO cities SELECT value, 'city-' || value FROM generate_series(1, 20);
INSERT INTO users
  SELECT value, 'user-' || value, 18 + (value % 60), 1 + (value % 20)
  FROM generate_series(1, 500);
INSERT INTO orders
  SELECT value, 1 + (value % 500), (value * 37) % 1000 / 10.0
  FROM generate_series(1, 2000);
INSERT INTO sessions
  SELECT value, 'sk_' || (1 + (value % 500)), 'device-' || (value % 7)
  FROM generate_series(1, 800);
INSERT INTO events
  SELECT value, 'sk_' || (1 + (value % 500)), 'kind-' || (value % 5)
  FROM generate_series(1, 3000);
ANALYZE;
