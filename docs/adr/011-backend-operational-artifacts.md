# ADR-011 — Runnable backend projects include standard operational artifacts

## Context

The SDD repository already defines the backend stack, module structure, migration strategy, containerization rules, and API testing conventions.

However, backend onboarding still becomes inconsistent when generated projects do not expose the same operational workflow for developers.

Typical drift appears in:

- missing or incompatible `Makefile` targets
- missing `.env.example`
- Docker artifacts generated differently across projects
- Postman files present but not treated as part of the default workflow

## Decision

Runnable backend projects include a standard operational artifact set.

Project-level artifacts must include:

- `Makefile`
- `.env.example`
- `Dockerfile`
- `docker-compose.yml`
- `.dockerignore`
- `postman/`

The `Makefile` must expose a common baseline for developer workflows, including formatting, dependency tidy, build, test, run, verification, Docker lifecycle commands, and local database helpers.

This ADR complements:

- ADR-007 for migration strategy
- ADR-008 for containerization
- ADR-009 for API testing artifacts

## Consequences

### Pros

- generated backends are usable immediately after scaffolding
- local onboarding becomes more predictable
- AI and generators have a stable operational target
- teams do not need to reinvent the same make/docker/postman workflow per backend

### Cons

- some repositories may need small variations around the default targets
- changing the standard workflow later requires updating multiple templates and docs
