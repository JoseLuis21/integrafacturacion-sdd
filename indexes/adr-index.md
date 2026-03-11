# ADR Index

This index tracks the most important architecture decision records (ADRs) in the project.

Use this file to quickly understand why major technical decisions were made.

---

# Consolidated ADR Documents

## ADRs Iniciales del Proyecto ERP

**File:** `docs/adr/000-adrs_iniciales.md`
**Summary:** Consolidates the initial architecture decisions for the ERP system, including database strategy (PostgreSQL), multi-tenant architecture, and foundational design choices.

---

# Current ADRs

## ADR-001 — PostgreSQL as the main database

**File:** `docs/adr/001-postgresql-main-database.md`
**Summary:** PostgreSQL is the primary database because the system needs strong transactions, relational queries, indexing flexibility, and solid support for business-critical workflows.

---

## ADR-002 — Multi-tenant strategy by control layer + tenant isolation

**File:** `docs/adr/002-multi-tenant-strategy.md`
**Summary:** The system separates global/shared concerns from tenant operational data to support isolation, security, and scalability.

---

## ADR-003 — UUID v7 for identifiers

**File:** `docs/adr/003-uuid-v7-identifiers.md`
**Summary:** Use UUID v7 generated in the application to avoid sequential exposure and improve insertion ordering characteristics.

---

## ADR-004 — Hexagonal architecture for backend modules

**File:** `docs/adr/004-hexagonal-architecture.md`
**Summary:** Backend modules are organized into domain, application, and infrastructure layers to improve separation of concerns and testability.

---

## ADR-005 — Modular monolith as initial backend strategy

**File:** `docs/adr/005-modular-monolith.md`
**Summary:** Start with a modular monolith instead of microservices to preserve consistency and reduce operational complexity early on.

---

## ADR-006 — Next.js + shadcn/ui for frontend

**File:** `docs/adr/006-nextjs-shadcn-frontend.md`
**Summary:** The frontend stack is based on Next.js, TypeScript, and shadcn/ui for modular, modern UI development.

---

## ADR-007 — Embedded SQL migrations as the default migration strategy

**File:** `docs/adr/007-database-migrations.md`
**Summary:** Backend projects use embedded SQL migrations with module ownership rules and a shared `schema_migrations` control table.

---

## ADR-008 — Standard containerization for runnable backends

**File:** `docs/adr/008-containerization.md`
**Summary:** Runnable backend scaffolds ship with `Dockerfile`, `docker-compose.yml`, standard healthchecks, and minimum environment variables.

---

## ADR-009 — Shared Postman collection and local API testing artifacts

**File:** `docs/adr/009-api-testing-artifacts.md`
**Summary:** API testing uses a single project collection with module folders, a standard local environment, and reusable auth capture scripts.

---

## ADR-010 — Auth middleware validates JWT and injects request auth context

**File:** `docs/adr/010-auth-middleware-contract.md`
**Summary:** Protected HTTP endpoints rely on middleware to validate bearer JWTs, map claims, and inject request-scoped auth values instead of parsing tokens in handlers.

---

## ADR-011 — Runnable backend projects include standard operational artifacts

**File:** `docs/adr/011-backend-operational-artifacts.md`
**Summary:** Runnable backend projects standardize `Makefile`, env template, Docker, and Postman artifacts so generated backends share the same developer workflow.

---

# How to Use ADRs

Read ADRs when:

- making a major architectural change
- wondering why a design choice exists
- evaluating whether a previous decision should be revised
- onboarding into the project

---

# ADR Lifecycle

A good ADR should contain:

- context
- decision
- consequences

When a decision changes significantly:

- create a new ADR
- reference the previous one
- explain the reason for the change

Do not silently rewrite history if the rationale matters.

---

# Notes

- Keep file names stable and explicit.
- Prefer one major decision per ADR.
- Add new ADRs here as the project evolves.
