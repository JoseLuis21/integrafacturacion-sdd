# Infrastructure Rules

These rules define the default operational artifacts for runnable backend projects.

## Project-level artifacts

Generate these once per backend repository:

- `Makefile`
- `Dockerfile`
- `docker-compose.yml`
- `.dockerignore`
- `.env.example`
- `internal/platform/database/migrations.go`
- `postman/base.postman_collection.json`
- `postman/local.postman_environment.json`

## Module-level artifacts

Generate or update these per module:

- SQL migration files for tables owned by the module
- Postman folders/items for the module endpoints
- request/response examples inside `specs/modules/<module>/module.json`

## Migration rules

- default runner: embedded SQL
- default control table: `schema_migrations`
- default naming: `000001_init_<module>_schema.sql`
- migrations belong under `internal/platform/database/migrations/`
- seeds stay separate from structural migrations
- if a module does not own a table, it must not create or rename that table in its migration set

## Container rules

- default services: `api` and `postgres`
- default compose file: `docker-compose.yml`
- default app healthcheck: HTTP `GET /health`
- default migration execution: inside the API binary
- standard developer commands should be available through `Makefile`
- if containerization is omitted, state why explicitly
