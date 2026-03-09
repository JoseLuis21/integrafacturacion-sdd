# Architecture & Foundation Index

This index provides an overview of architecture decisions, patterns, and shared infrastructure components that all modules build upon.

Use this file to understand the foundational systems and architectural patterns of the project.

---

# Architecture Documents

- `docs/architecture/architecture.md` — High-level architectural principles and development workflow
- `docs/architecture/frontend-foundation.md` — Frontend base infrastructure (routes, layout, API client, stores, shared components)

---

# Foundation Components

## Frontend Foundation

**Purpose:** frontend base infrastructure (routes, layout, api client, stores, shared components)

**Context:** 
- `context/core/frontend-structure.md` (quick reference)
- `docs/architecture/frontend-foundation.md` (detailed)

Includes:

- Route groups: `(landing)/`, `(auth)/`, `(dashboard)/`
- App shell: sidebar, topbar, user menu, breadcrumbs
- API client with typed responses
- Zustand stores (auth, ui state)
- shared components (DataTable, EmptyState, ConfirmDialog, etc.)
- route protection middleware
- module structure convention
- shadcn/ui v4 with Base UI integration

---

# Recommended Reading Order

For new contributors understanding the project foundation:

1. `docs/architecture/architecture.md`
2. `context/core/architecture-summary.md`
3. `docs/architecture/frontend-foundation.md` (if working on frontend)
4. `indexes/modules-index.md` (to understand business modules)

---

# Notes

- Architecture components are not business domain modules — they provide infrastructure for modules to build upon.
- All business modules must follow the patterns and conventions defined in these architecture documents.
