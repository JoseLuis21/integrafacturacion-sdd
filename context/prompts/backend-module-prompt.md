# Backend Module Prompt

Use this prompt to generate or implement backend code for one module.

---

## Prompt Template

Using the following context:

- `context/core/architecture-summary.md`
- `context/core/coding-rules.md`
- `context/core/naming-rules.md`
- `context/core/ai-workflow.md`
- `context/modules/<module>.context.md`
- `docs/modules/<module>.md`
- `specs/modules/<module>/module.json`

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

Requested output:
- domain entity or entities
- repository interface
- DTOs
- use case skeletons or implementation (depending on request)
- HTTP handler skeletons or implementation
- routes
- module registration file if needed

If a rule is ambiguous, do not invent a final answer silently.
Instead, leave a clear TODO or note the assumption explicitly.
