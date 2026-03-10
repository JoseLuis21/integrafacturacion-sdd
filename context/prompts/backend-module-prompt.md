# Backend Module Prompt

Use this prompt to generate or implement backend code for one module.

---

## Prompt Template

Using the following context:

**Core Rules:**

- `context/core/architecture-summary.md`
- `context/core/coding-rules.md`
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

Constraints:

- Use Go
- Use Fiber v2
- Use PostgreSQL
- Follow Hexagonal Architecture
- Keep domain independent from infrastructure
- Use the existing module structure
- Do not modify unrelated modules
- Do not invent complex business rules not present in the spec
- Include a `Dockerfile` for the runnable backend service by default
- Include a `compose.yaml` when the module needs PostgreSQL, cache, or other local support services
- If containerization is intentionally omitted, state the reason explicitly

Requested output:

- domain entity or entities
- repository interface
- DTOs
- use case skeletons or implementation (depending on request)
- HTTP handler skeletons or implementation
- routes
- module registration file if needed
- `Dockerfile`
- `compose.yaml` when local dependencies are required

If the target backend repository is empty or missing reusable structure, generate the module using the framework conventions and templates as the source of truth.

Do not treat the absence of code as a blocker.
Do not try to infer architecture from unrelated repositories.
Prefer explicit placeholders for undefined infrastructure decisions.

If a rule is ambiguous, do not invent a final answer silently.
Instead, leave a clear TODO or note the assumption explicitly.
