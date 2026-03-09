# Frontend Structure Context

## Purpose

This file gives AI and developers a short summary of the frontend project structure and conventions.

Load this file when implementing any frontend feature.

---

## Project

Repository: `integrafacturacion`
Stack: Next.js 14.2, TypeScript 5.7, shadcn/ui v4 (Base UI), Zustand 5, Zod 3

---

## Route Groups

- `(landing)/` — Marketing/landing pages (public)
- `(auth)/` — Authentication pages: login, forgot-password, reset-password, verify-email, set-password
- `(dashboard)/` — Authenticated ERP application with AppShell layout

---

## Key Directories

- `src/app/` — Next.js App Router pages
- `src/components/layout/` — AppShell, sidebar, topbar, user-menu, breadcrumb
- `src/components/shared/` — Reusable: DataTable, EmptyState, ErrorState, ConfirmDialog, LoadingSkeleton, PageHeader, PermissionGuard
- `src/components/ui/` — shadcn/ui generated components
- `src/config/` — Navigation items, constants
- `src/hooks/` — Shared hooks: use-current-user, use-permission, use-auth
- `src/modules/` — Business modules (auth, product, customer, etc.)
- `src/providers/` — AuthProvider
- `src/schemas/` — Shared Zod validators (RUT, email, phone, password)
- `src/services/` — API client, error mapper
- `src/stores/` — Zustand stores (auth, ui)
- `src/types/` — Shared TypeScript types (api, auth, common)

---

## Module Convention

Each module at `src/modules/{module}/` contains:

```
components/  — Module-specific UI
hooks/       — Module-specific hooks
services/    — API calls ({module}.service.ts)
schemas/     — Zod schemas
types/       — TypeScript types
```

---

## Adding a New Page

1. Create page at `src/app/(dashboard)/{route}/page.tsx`
2. Add nav item to `src/config/navigation.ts`
3. Add breadcrumb label to `src/components/layout/breadcrumb-nav.tsx`

---

## API Client

Located at `src/services/api-client.ts`. Uses native fetch.

```typescript
apiClient.get<T>(path)
apiClient.post<T>(path, body)
apiClient.patch<T>(path, body)
apiClient.delete<T>(path)
```

Auto-attaches auth token from cookies. On 401, clears auth and redirects to /login.

---

## State Management

- `src/stores/auth.store.ts` — User, companies, permissions, isAuthenticated
- `src/stores/ui.store.ts` — Sidebar collapsed/open state

---

## Permissions

Use `usePermission("module.action")` hook or `<PermissionGuard permission="module.action">` component.

Currently in stub mode (grants all). Will use real permissions from `/auth/me` response.

---

## shadcn v4 Note

shadcn v4 uses **Base UI** instead of Radix UI.

Key API differences:
- No `asChild` — use `render` prop instead
- No `forceMount` or `delayDuration` props
- Component APIs follow Base UI patterns
