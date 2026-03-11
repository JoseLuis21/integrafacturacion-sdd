# ADR-008 — Standard containerization for runnable backends

## Context

The repository recommended Docker artifacts, but it did not define a stable contract for:

- file names
- minimum services
- healthchecks
- required environment variables
- where migrations run

That makes generated backend scaffolds inconsistent and harder to operate locally.

## Decision

Runnable backend scaffolds use a standard container contract.

Rules:

- include `Dockerfile`, `docker-compose.yml`, and `.dockerignore`
- default compose services are `api` and `postgres`
- the backend exposes a healthcheck on `GET /health`
- minimum environment variables are `APP_ENV`, `APP_PORT`, `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `DB_SSLMODE`, and `DB_AUTO_MIGRATE`
- the default local startup command is `docker compose up --build`
- migrations run inside the same backend binary by default unless another ADR says otherwise

If the generated deliverable is not runnable, the exception must be explicit in the spec or prompt.

## Consequences

### Pros

- faster bootstrap for local development
- fewer container naming differences across projects
- easier health and readiness validation
- predictable AI output for backend scaffolds

### Cons

- some projects may need extra services or a separate migration job
- production deployments may still require environment-specific overrides
