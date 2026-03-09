# Architecture Summary

## Purpose

This file gives AI and developers a short, reusable summary of the project architecture.

It should be loaded when implementing almost any feature.

---

## Project Style

This project follows a **Specification Driven Development** workflow.

Flow:

```text
idea
→ feature spec (.md)
→ structured spec (.json)
→ boilerplate generation
→ implementation
→ tests
```

The specification is the source of truth before code.

---

## Repository Strategy

This project is designed for a **multirepo** setup.

Typical repositories:

- `specs` → specs, docs, context, prompts
- `backend` → backend implementation
- `frontend` → frontend implementation

Specs should not be duplicated across repos.

---

## Knowledge Layers

The project separates knowledge into three layers:

### `docs/`

Human-readable design documentation.

### `specs/`

Structured machine-readable definitions used for generation.

### `context/`

Short context files optimized for AI prompts.

---

## Backend Architecture

Recommended backend stack:

- Go
- Fiber v2
- PostgreSQL
- Hexagonal Architecture
- UUID v7 generated in the application

### Hexagonal layers

- `domain` → business entities, value objects, repository interfaces, business rules
- `application` → use cases, DTOs, orchestration, transactions
- `infrastructure` → HTTP, persistence, external providers

### Rule

The domain layer must not depend on infrastructure.

---

## Frontend Architecture

Recommended frontend stack:

- Next.js
- TypeScript
- shadcn/ui
- React Hook Form
- Zod
- Zustand for state management
- Use Server Actions for server mutations if appropriate

### Frontend organization

Organize by domain/module, not by file type only.

Examples:

- `modules/auth`
- `modules/product`
- `modules/customer`

---

## Multi-Tenant Strategy

Recommended multi-tenant design:

- control database for shared/global concerns
- tenant database or tenant schemas for operational data

Typical split:

### Control DB

- users
- companies
- company_users
- roles
- permissions
- auth tokens
- API keys

### Tenant DB / schemas

- customers
- suppliers
- products
- purchases
- sales
- inventory
- payments
- folios
- DTE data

---

## Source of Truth

Never treat generated code as the original design source.

The source of truth is:

- feature spec
- structured spec
- core conventions
- architecture decisions

---

## Generation Philosophy

Use automation for:

- boilerplate
- DTOs
- handlers
- routes
- schemas
- services
- hooks
- forms base

Do not blindly generate or automate:

- complex business rules
- accounting logic
- inventory engine logic
- tax logic
- high-risk security flows

---

## Change Strategy

When an existing module needs a new major capability:

- create a change spec
- implement the change
- then merge the new behavior into the main module spec

Examples:

- `auth` + Google OAuth
- `sale` + discount rules
- `inventory` + stock reservation

---

## AI Usage Rule

AI should be used with:

- relevant module spec
- structured spec JSON
- core context
- project conventions

Do not load the entire project into the prompt unless absolutely necessary.

Use the **smallest relevant context** for the task.

---

## Summary

This project is:

- spec-first
- modular
- AI-assisted
- architecture-controlled
- generation-friendly
- designed to scale without losing clarity
