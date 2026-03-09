# Coding Rules

## Purpose
This file defines reusable coding rules for backend and frontend generation and implementation.

Load this file whenever AI is asked to generate or modify code.

---

## General Rules
- Prefer clear and explicit code over clever code.
- Keep functions focused and small.
- Use stable naming.
- Avoid hidden side effects.
- Do not mix domain logic with transport logic.
- Do not invent architecture that is not already defined.

---

## Backend Rules

### Language and stack
- Use Go.
- Use Fiber v2 for HTTP.
- Use PostgreSQL for persistence.
- Use UUID v7 generated in the application.
- Follow hexagonal architecture.

### Layering
- `domain` must not depend on HTTP, SQL, Fiber, or framework-specific code.
- `application` orchestrates use cases and transactions.
- `infrastructure` contains concrete implementations.

### Domain rules
- Entities should model business concepts, not raw DB rows.
- Business rules belong in domain or application, not in handlers.
- Repository interfaces belong close to the domain that consumes them.

### HTTP rules
- Handlers should stay thin.
- Validate request input before passing to use cases.
- Use consistent response shapes.
- Avoid putting business logic inside handlers.

### Persistence rules
- Keep SQL/persistence details out of the domain.
- Use repository implementations in infrastructure.
- Prefer explicit queries over magical hidden behavior.

### Errors
- Use clear domain/application errors.
- Map errors to HTTP in infrastructure.
- Do not leak internal implementation details in API responses.

### Transactions
- Use transactions in application/use cases when one action affects multiple tables or invariants.
- Do not scatter transaction control across unrelated layers.

### Tests
- Test business rules and use cases.
- Prefer meaningful test names.
- Cover happy path and key failure cases.

---

## Frontend Rules

### Language and stack
- Use Next.js.
- Use TypeScript.
- Use shadcn/ui.
- Use React Hook Form and Zod where forms are involved.

### Organization
- Organize by module/domain.
- Keep global reusable components in shared/global component folders.
- Keep module-specific components inside module folders.

### Components
- Components should have one main responsibility.
- Avoid giant page files with too much embedded logic.
- Move API access into services/hooks, not inline in UI components.

### Forms
- Keep form schema separate from component rendering when practical.
- Show inline validation errors.
- Keep loading/submission state explicit.

### Data fetching
- Use services/hooks consistently.
- Do not scatter raw fetch logic across many components.

### Permissions
- UI should hide or disable unauthorized actions.
- Page-level access control should be explicit.

---

## AI Generation Rules
When generating code:
- follow existing module structure
- do not modify unrelated files
- do not create new patterns without reason
- prefer placeholders for complex logic instead of inventing unsafe logic
- make TODOs explicit when real implementation depends on business decisions

---

## Refactor Rules
When refactoring:
- preserve behavior unless change is explicitly requested
- avoid renaming core concepts casually
- do not merge unrelated concerns into one file
- keep architectural boundaries intact

---

## Final Rule
Generated code should be:
- readable
- predictable
- modular
- easy to review
- easy to replace or improve later
