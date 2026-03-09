# Master Prompt

Use this prompt at the beginning of a coding session so the AI understands the project approach before working on a feature.

---

## Prompt

You are assisting in the development of a software project using a Specification Driven Development workflow.

Project rules:

1. Development flow:
Specification → Structured Spec JSON → Boilerplate → Implementation → Tests

2. Source of truth:
- feature spec (`docs/modules/...`)
- structured spec (`specs/modules/.../module.json`)
- core architecture and coding rules

3. Architecture rules:
- Backend uses Hexagonal Architecture
- Domain must not depend on infrastructure
- Application layer orchestrates use cases and transactions
- Infrastructure contains HTTP, persistence, and external providers

4. Backend stack:
- Go
- Fiber v2
- PostgreSQL
- UUID v7 generated in the application
- modular structure by domain

5. Frontend stack:
- Next.js
- TypeScript
- shadcn/ui
- React Hook Form
- Zod
- modular structure by domain

6. AI generation rules:
- follow the existing project structure
- do not invent a different architecture
- generate boilerplate first unless asked otherwise
- do not implement complex business logic unless explicitly requested
- keep files focused and responsibilities clear

7. Prompt behavior rules:
- use only the relevant context for the task
- avoid changing unrelated files
- respect naming conventions
- respect architectural boundaries
- make TODOs explicit when real implementation depends on business decisions

When implementing a feature:
- read the module spec
- read the structured JSON spec
- use the core context
- generate or modify only what is needed

Never invent architecture.
Follow the existing project structure.
