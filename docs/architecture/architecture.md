
# Architecture Overview

This document describes the high‑level architecture of the system and the development workflow used in this project.

The project follows an **AI‑assisted, Specification Driven Development (SDD)** approach designed for scalable SaaS and ERP‑style systems.

---

# 1. Architectural Principles

The architecture is based on the following principles:

- **Specification First**
- **Modular Domain Design**
- **Hexagonal Architecture**
- **AI‑assisted Development**
- **Clear separation of responsibilities**
- **Multi‑tenant readiness**
- **Automation friendly**

The goal is to make the system:

- easy to evolve
- easy to reason about
- easy to generate boilerplate for
- safe for AI‑assisted implementation

---

# 2. Development Workflow

Development follows this sequence:

```
idea
→ feature spec (.md)
→ structured spec (.json)
→ boilerplate generation
→ implementation
→ tests
```

### Explanation

**Idea**  
A new capability or change is proposed.

**Feature Spec (`docs/modules/*.md`)**  
Human readable description of the module or feature.

**Structured Spec (`specs/modules/*.json`)**  
Machine readable definition used for generation.

**Boilerplate Generation**  
A CLI (ex: `modulegen`) generates the base code structure.

**Implementation**  
Developers or AI implement business logic.

**Tests**  
Tests validate business rules and system behavior.

---

# 3. Repository Strategy

The project is designed to work well with a **multi‑repository setup**.

Typical repositories:

```
erp-specs
erp-backend
erp-frontend
```

### erp-specs

Contains:

```
docs/
specs/
context/
prompts/
```

Purpose:

- architecture documentation
- feature specifications
- AI context files
- reusable prompts

This repo acts as the **design source of truth**.

---

### erp-backend

Contains the backend implementation.

Recommended stack:

- Go
- Fiber v2
- PostgreSQL
- UUID v7

Architecture style:

**Hexagonal Architecture**

---

### erp-frontend

Contains the frontend application.

Recommended stack:

- Next.js
- TypeScript
- shadcn/ui
- React Hook Form
- Zod

Frontend is organized **by domain module**.

---

# 4. Backend Architecture

The backend follows **Hexagonal Architecture**.

Example structure:

```
internal/
  modules/
    product/
      domain/
      application/
      infrastructure/
```

### Domain

Contains:

- entities
- value objects
- repository interfaces
- domain rules

The domain layer **must not depend on infrastructure**.

---

### Application

Contains:

- use cases
- DTOs
- orchestration
- transaction boundaries

Application coordinates domain behavior.

---

### Infrastructure

Contains:

- HTTP handlers
- database repositories
- external providers

Infrastructure depends on domain and application.

---

# 5. Frontend Architecture

Frontend is organized by **modules**.

Example:

```
src/
  modules/
    auth/
    product/
    customer/
```

Each module typically contains:

```
components/
hooks/
services/
schemas/
types/
pages/
```

Responsibilities:

- UI components
- API communication
- forms
- state management

---

# 6. Multi‑Tenant Design

The system is designed for **multi‑tenant SaaS environments**.

Two common layers:

### Control Database

Stores global data such as:

```
users
companies
company_users
roles
permissions
auth_tokens
api_keys
```

---

### Tenant Database / Schemas

Stores operational data such as:

```
products
customers
suppliers
sales
purchases
inventory
payments
folios
DTE data
```

Each tenant operates on its own dataset.

---

# 7. Module Design

The system is organized into domain modules.

Examples:

```
auth
product
customer
supplier
sale
purchase
inventory
payment
```

Each module owns:

- its domain entities
- its use cases
- its API endpoints
- its UI components

Modules should remain **loosely coupled**.

---

# 8. Automation Philosophy

Automation is used to generate predictable structure.

Examples of generated artifacts:

- DTOs
- handler skeletons
- route registration
- frontend services
- hooks
- schemas
- form scaffolding

Automation should **not attempt to generate complex business rules**.

---

# 9. AI Usage Strategy

AI is used as an **accelerator**, not as the architect.

AI should assist with:

- spec review
- spec → JSON conversion
- boilerplate generation
- use case implementation
- test generation
- refactoring suggestions

Developers remain responsible for:

- architecture decisions
- business rules validation
- security concerns
- code review

---

# 10. Change Strategy

When adding a new capability to an existing module:

1. Create a change spec in `docs/changes/`
2. Create a structured change spec in `specs/modules/<module>/changes/`
3. Implement the change
4. Merge the new behavior into the main module spec

Example:

```
auth + Google OAuth
sale + discount rules
inventory + reservations
```

---

# 11. Source of Truth

The system design should always come from:

1. Architecture documentation
2. Feature specifications
3. Structured specs
4. Coding conventions

Generated code is **not the design source of truth**.

---

# 12. Summary

This architecture is designed to support:

- scalable SaaS systems
- ERP‑level domain complexity
- AI‑assisted development
- modular evolution
- maintainable codebases

Core characteristics:

- spec‑first development
- modular domain design
- hexagonal backend architecture
- domain‑based frontend organization
- AI‑friendly structure
