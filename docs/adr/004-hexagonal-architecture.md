# ADR-004 — Hexagonal Architecture

## Context

The backend must support:

- clear separation of business logic
- testability
- maintainability as modules grow
- easy replacement of infrastructure components

Traditional layered architectures often allow domain logic to leak into controllers or database code.

Hexagonal architecture (also known as Ports and Adapters) enforces stronger separation.

## Decision

Adopt **Hexagonal Architecture** for backend modules.

Each module is organized into:

### Domain

Contains:

- entities
- value objects
- domain services
- repository interfaces
- business rules

The domain layer must not depend on infrastructure.

### Application

Contains:

- use cases
- orchestration logic
- DTOs
- transaction boundaries

### Infrastructure

Contains:

- HTTP handlers
- database repositories
- external integrations
- framework-specific code

## Consequences

### Pros

- clear boundaries
- easier testing of business logic
- easier refactoring
- infrastructure can change without affecting domain

### Cons

- slightly more boilerplate
- developers must respect architectural boundaries