# Backend Module Prompt

Use this prompt to generate or implement backend code for one module inside an existing backend foundation.

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

**Module-Specific:**

- `context/modules/<module>.context.md`
- `docs/modules/<module>.md`
- `specs/modules/<module>/module.json`

**Project Knowledge (as needed):**

- `docs/conventions/` — Coding & naming conventions
- `docs/glossary/` — Domain terminology
- `docs/architecture/` — Architecture decisions & patterns
- `docs/adr/` — Architecture Decision Records

**Additional Discovery:**

- `indexes/` — Use to find relevant documentation, ADRs, and context files

Generate the backend code for the `<module>` module.

If the backend repository is empty or still lacks project-level foundations, use `context/prompts/backend-foundation-prompt.md` first.

Constraints:

- Use Go
- Use Fiber v2
- Use PostgreSQL
- Follow Hexagonal Architecture
- Keep domain independent from infrastructure
- Use the existing module structure
- Assume project-level foundations already exist unless the task explicitly includes foundation work
- If a project-level artifact already exists, update only the minimum required section; do not recreate it
- Do not modify unrelated modules
- Do not invent complex business rules not present in the spec
- Include migration files for module-owned tables when the module changes persistence
- If the module exposes protected endpoints, define the auth header, claims contract, middleware context keys, and unauthorized response explicitly
- Keep project-level changes separate from module-level changes
- Do not create `Makefile`, `.env.example`, `Dockerfile`, `docker-compose.yml`, or base `postman/` artifacts as part of this prompt unless the task explicitly asks for foundation work
- Update shared Postman collection or shared middleware only when the module contract requires it
- If containerization is intentionally omitted, state the reason explicitly

Requested output:

- `Project-level changes`
- `Module-level changes`
- domain entity or entities
- repository interface
- DTOs
- use case skeletons or implementation (depending on request)
- HTTP handler skeletons or implementation
- routes
- module registration file if needed
- migration files when persistence changes
- auth middleware contract when endpoints are protected
- Postman updates when HTTP endpoints are exposed

Do not treat the absence of code as a blocker.
Do not try to infer architecture from unrelated repositories.
Prefer explicit placeholders for undefined infrastructure decisions.

If a rule is ambiguous, do not invent a final answer silently.
Instead, leave a clear TODO or note the assumption explicitly.
