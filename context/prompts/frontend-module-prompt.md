# Frontend Module Prompt

Use this prompt to generate or implement frontend code for one module.

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

Generate the frontend code for the `<module>` module.

Constraints:

- Use Next.js
- Use TypeScript
- Use shadcn/ui
- Use React Hook Form
- Use Zod
- Use Zustand for state management if needed
- Use Server Actions for server mutations if appropriate
- Organize code by module/domain
- Do not place module-specific logic in unrelated shared folders
- Do not invent API contracts that are not present in the spec

Requested output:

- TypeScript types
- Zod schemas
- service functions
- hooks
- form component
- table/list component
- page skeletons if needed

If something is not defined clearly in the spec, make the uncertainty explicit instead of inventing it silently.
