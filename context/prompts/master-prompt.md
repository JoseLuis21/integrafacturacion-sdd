# Master Prompt

Use this prompt at the beginning of a coding session so the AI understands the project approach before working on a feature.

---

## Essential Context Files

Before starting work, load these core documents:

1. **[AI Workflow](../core/ai-workflow.md)** — Development flow and source of truth
2. **[Architecture Summary](../core/architecture-summary.md)** — Project structure and design approach
3. **[Coding Rules](../core/coding-rules.md)** — Backend and frontend standards
4. **[Naming Rules](../core/naming-rules.md)** — Stable naming conventions
5. **Module Context** — Read the relevant module doc under `context/modules/{moduleName}/`

---

## Development Workflow

Follow the **Specification Driven Development** flow:

```text
idea
→ feature spec (docs/modules/{module}/)
→ structured spec (specs/modules/{module}/)
→ boilerplate generation
→ implementation
→ tests
```

**Key rule:** Do not start with code if the feature is not clearly specified.

---

## Source of Truth (in order)

1. Feature spec (`docs/modules/{module}/`)
2. Structured spec (`specs/modules/{module}/{module}.json`)
3. Module context (`context/modules/{module}/`)
4. Core rules from `context/core/`

Generated code is not the source of truth.

---

## When Implementing a Feature

1. Read the module spec in `docs/modules/{module}/`
2. Read the structured JSON spec in `specs/modules/{module}/`
3. Load relevant core context (architecture, coding rules, naming)
4. Read module-specific context under `context/modules/{module}/`
5. Generate or modify only what is needed
6. Respect architectural boundaries and naming conventions

---

## AI Generation Rules

- Follow the existing project structure
- Do not invent a different architecture
- Generate boilerplate first unless asked otherwise
- Include `Dockerfile` and `compose.yaml` by default for runnable services or applications
- If Docker artifacts are omitted, state the reason explicitly
- Do not implement complex business logic unless explicitly requested
- Keep files focused and responsibilities clear
- Avoid changing unrelated files
- Make TODOs explicit when implementation depends on business decisions
