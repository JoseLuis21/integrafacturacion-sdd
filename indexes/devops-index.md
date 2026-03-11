# DevOps Index

This index groups the operational-artifact contract for backend generation.

## ADRs

- `docs/adr/007-database-migrations.md`
- `docs/adr/008-containerization.md`
- `docs/adr/009-api-testing-artifacts.md`
- `docs/adr/011-backend-operational-artifacts.md`

## Core context

- `context/core/infrastructure-rules.md`
- `context/core/operational-artifacts-rules.md`
- `context/core/api-artifacts-rules.md`
- `context/core/environment-rules.md`
- `context/core/repository-structure.md`

## Templates

- `templates/project/backend/Dockerfile`
- `templates/project/backend/docker-compose.yml`
- `templates/project/backend/.dockerignore`
- `templates/project/backend/Makefile`
- `templates/project/backend/internal/platform/database/migrations.go`
- `templates/project/backend/internal/platform/database/migrations/000001_init.sql`
- `templates/project/backend/postman/base.postman_collection.json`
- `templates/project/backend/postman/local.postman_environment.json`

## Related specs

- `templates/module-json-template.json`
- `specs/modules/<module>/module.json`
