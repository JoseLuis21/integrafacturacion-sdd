# ADR-007 — Embedded SQL migrations as the default migration strategy

## Context

The SDD repository already defines stack, architecture, and module structure, but it did not define how backend projects should generate and own database migrations.

Without a shared contract, different generated projects may:

- mix migration tools and runners
- place migration files in inconsistent folders
- let unrelated modules modify each other's tables
- run schema changes differently in local, CI, and production

The backend stack already assumes PostgreSQL and modular ownership, so the migration strategy must preserve that.

## Decision

Use embedded SQL migrations as the default backend strategy.

Rules:

- migrations live under `internal/platform/database/migrations/`
- the migration runner is project-level code in `internal/platform/database/migrations.go`
- the default control table is `schema_migrations`
- module-owned tables must be changed only by the module that owns them
- the default naming pattern is `000001_init_<module>_schema.sql`
- seeds are separate from schema migrations and are not part of the default auto-run path
- runnable backend scaffolds may auto-run migrations on startup through the same API binary, controlled by configuration

This ADR defines the default. A project may adopt an external tool later, but that change must be explicit in a new ADR.

## Consequences

### Pros

- one repeatable migration flow across generated backends
- simpler local setup
- easier AI generation because folder, runner, and naming are fixed
- ownership boundaries stay aligned with module boundaries

### Cons

- projects using advanced external tooling will need an explicit exception
- startup migration execution must be controlled carefully outside local/dev environments
