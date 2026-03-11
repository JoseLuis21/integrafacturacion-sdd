# Repository Structure

## Backend root

- `.env.example`
- `.dockerignore`
- `Dockerfile`
- `Makefile`
- `docker-compose.yml`
- `cmd/api/main.go`
- `internal/bootstrap/`
- `internal/shared/http/`
- `internal/platform/database/`
- `internal/platform/database/migrations/`
- `internal/shared/`
- `internal/platform/`
- `internal/modules/<module>/`
- `postman/`

## Operational Artifacts

Backend projects should include:

- a `Makefile` for standard developer workflows
- a `Dockerfile` for building the API
- a `docker-compose.yml` for local dependencies
- a `postman/` folder for API testing artifacts

## Module structure

Each backend module must use:

- `domain/`
- `application/dto/`
- `application/usecases/`
- `infrastructure/persistence/postgres/`
- `infrastructure/http/`
- `module.go`

## Ownership rules

- Project-level artifacts live at backend root or under `internal/platform/`.
- Module-level SQL migrations are created by the module that owns the table.
- Module-level Postman requests are grouped inside the shared project collection by module folder.
- Do not create parallel folders like `db/`, `infra/`, `collections/`, or root-level `migrations/` if this structure already exists.

## Rule

If the repository is empty, generate the module using this structure.
Do not invent a different folder layout.
