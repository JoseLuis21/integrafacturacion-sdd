# Operational Artifacts Rules

- Every runnable backend project should define operational artifacts for local development and onboarding.
- Project-level operational artifacts include:
  - `Makefile`
  - `Dockerfile`
  - `docker-compose.yml`
  - `.dockerignore`
  - `.env.example`
  - `postman/`
- Database migrations must have a declared strategy.
- Migrations must be versioned and deterministic.
- Protected endpoints must include importable API testing artifacts.
- Standard developer commands must be exposed through `Makefile`.
- Do not invent different operational workflows across generated backends without an ADR.
