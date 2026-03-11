-- Project bootstrap migration.
-- Keep module-specific tables in dedicated files such as:
-- 000002_init_auth_schema.sql

CREATE EXTENSION IF NOT EXISTS pgcrypto;
