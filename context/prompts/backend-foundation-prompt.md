# Backend Foundation Prompt

Use this prompt to bootstrap a runnable backend repository or to add missing project-level foundations.

---

## Prompt Template

Using the following context:

**Core Rules:**

- `context/core/architecture-summary.md`
- `context/core/coding-rules.md`
- `context/core/infrastructure-rules.md`
- `context/core/operational-artifacts-rules.md`
- `context/core/api-artifacts-rules.md`
- `context/core/auth-middleware-rules.md`
- `context/core/naming-rules.md`
- `context/core/environment-rules.md`
- `context/core/ai-workflow.md`
- `context/core/repository-structure.md`

**Specs and Modules (as needed):**

- `docs/modules/<module>.md`
- `context/modules/<module>.context.md`
- `specs/modules/<module>/module.json`

**Templates:**

- `templates/project/backend/`
- `templates/module-json-template.json`

**Additional Discovery:**

- `indexes/` — Use to find relevant documentation, ADRs, and context files

Generate or update the backend foundation for the target project.

Constraints:

- Use Go
- Use Fiber v2
- Use PostgreSQL
- Follow Hexagonal Architecture
- Create or update project-level artifacts only
- If a project-level artifact already exists, update it; do not recreate it blindly
- Keep domain-independent shared concerns under `internal/shared/`
- Keep database runners and shared operational code under `internal/platform/`
- Do not implement detailed module business logic unless the task explicitly asks for initial module scaffolding too

Project-level artifacts include:

- `.env.example`
- `.dockerignore`
- `Makefile`
- `Dockerfile`
- `docker-compose.yml`
- `cmd/api/main.go`
- `internal/bootstrap/`
- `internal/platform/database/`
- `internal/shared/http/auth_middleware.go`
- `postman/`

Requested output:

- foundation summary
- `Project-level changes`
- `Module-level changes` only if the request explicitly includes module scaffolding
- assumptions and TODOs

If the backend repository is empty, start with this prompt before using `backend-module-prompt.md`.
