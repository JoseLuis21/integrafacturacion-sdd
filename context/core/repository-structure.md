# Repository Structure

## Backend root

- `cmd/api/main.go`
- `internal/bootstrap/`
- `internal/shared/`
- `internal/platform/`
- `internal/modules/<module>/`

## Module structure

Each backend module must use:

- `domain/`
- `application/dto/`
- `application/usecases/`
- `infrastructure/persistence/postgres/`
- `infrastructure/http/`
- `module.go`

## Rule

If the repository is empty, generate the module using this structure.
Do not invent a different folder layout.
