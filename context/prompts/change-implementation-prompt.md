# Change Implementation Prompt

Use this prompt when implementing a new feature/change on top of an existing module.

---

## Prompt Template

We are implementing a change for an existing module.

Use the following context:

- `context/core/architecture-summary.md`
- `context/core/coding-rules.md`
- `context/core/naming-rules.md`
- `context/core/ai-workflow.md`
- `context/modules/<module>.context.md`
- `docs/modules/<module>.md`
- `specs/modules/<module>/module.json`
- `docs/changes/<change>.md`
- `specs/modules/<module>/changes/<change>.json`

Task:
Implement the `<change>` change for the `<module>` module.

Constraints:

- Preserve the current behavior of the existing module unless the change explicitly alters it
- Do not redesign the module unnecessarily
- Touch only the files that are relevant to the change
- Keep naming and architecture consistent
- Make compatibility risks explicit
- If the change requires new tables, providers, routes, or UI elements, add only the minimum required structure first
- If the change introduces a new runnable service or changes local runtime dependencies, update `Dockerfile` and `compose.yaml`
- If Docker artifacts are intentionally not updated, state the reason explicitly

Expected output:

- implementation plan
- affected files
- code changes or skeletons
- explicit notes about assumptions, risks, or pending decisions
- explicit note about whether `Dockerfile` and `compose.yaml` must be created or updated
