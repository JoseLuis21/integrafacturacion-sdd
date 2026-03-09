# ADR-006 — Next.js + shadcn/ui Frontend

## Context

The frontend must support:

- modular UI development
- fast development velocity
- modern React architecture
- good developer experience

Several frontend stacks were considered:

- plain React
- Next.js
- Vue
- Angular

Next.js provides:

- server components
- routing system
- strong ecosystem
- good performance defaults

For UI components, shadcn/ui provides:

- accessible components
- Tailwind integration
- full control of source code

## Decision

Use **Next.js + TypeScript + shadcn/ui** for the frontend.

Key libraries:

- Next.js
- TypeScript
- shadcn/ui
- React Hook Form
- Zod

Frontend will be organized by **modules**:

src/modules/<module>/

## Consequences

### Pros

- modern React architecture
- strong typing with TypeScript
- flexible UI system
- scalable module organization

### Cons

- requires understanding of React ecosystem
- server/client boundary must be understood