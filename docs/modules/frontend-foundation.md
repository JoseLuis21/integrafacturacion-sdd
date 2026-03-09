# Module: Frontend Foundation

## Purpose

The `frontend-foundation` module defines the base infrastructure of the Next.js ERP application. It provides the shared architecture that all business modules (auth, product, sale, inventory, etc.) will build upon.

This is not a business domain module — it is the **structural skeleton** of the frontend application.

---

# Scope

This module includes:

- Route group structure: `(landing)/`, `(auth)/`, `(dashboard)/`
- App shell: sidebar, topbar, breadcrumbs, user menu, theme toggle
- API client: typed fetch wrapper with auth header injection and error handling
- State management: Zustand stores for auth and UI state
- Route protection: Next.js middleware for authenticated routes
- Auth provider: session validation on mount
- Shared components: DataTable, EmptyState, ErrorState, ConfirmDialog, LoadingSkeleton, PageHeader, PermissionGuard
- Shared hooks: `useCurrentUser`, `usePermission`, `useAuth`
- Shared types: API response types, auth types, common types
- Shared schemas: RUT, email, phone, password validators (Zod)
- Navigation config: data-driven sidebar navigation
- Module structure convention: `src/modules/{module}/`

This module does **not** include:

- Business module implementations (auth forms, product CRUD, etc.)
- Backend API implementation
- Testing framework
- CI/CD configuration
- Real API integration (uses stubs initially)

---

# Architecture Decisions

## AD-01: Native fetch wrapper (not Axios)
Next.js 14 optimizes native fetch with caching and revalidation. Axios adds 15KB+ for features we don't need. A thin typed wrapper gives us the same interceptor pattern.

## AD-02: Token storage in cookies
Next.js middleware runs on Edge runtime and can only read cookies. Access token stored in a cookie named `auth-token` for middleware route protection. Zustand store holds user profile data, not the raw token.

## AD-03: Zustand with persist
Auth state survives page reloads via Zustand persist middleware. UI preferences (sidebar collapsed state) persist to localStorage.

## AD-04: Sidebar Sheet for mobile
Desktop: fixed collapsible sidebar with icon-only mode. Mobile: shadcn Sheet component as drawer overlay.

## AD-05: Permission stub with real interface
`usePermission` hook returns `true` for all permissions in stub mode (with dev console warning). Components use `<PermissionGuard>` from day one. When backend delivers real permissions via `/auth/me`, only the store internals change.

## AD-06: shadcn v4 with Base UI
shadcn v4 uses Base UI instead of Radix UI. Key API differences: `asChild` replaced with `render` prop, `forceMount` and `delayDuration` do not exist. All components generated with this version.

---

# File Structure

```text
src/
├── app/
│   ├── (landing)/              ← Landing page (unchanged)
│   ├── (auth)/
│   │   ├── layout.tsx          ← Centered card layout
│   │   ├── login/page.tsx
│   │   ├── forgot-password/page.tsx
│   │   ├── reset-password/page.tsx
│   │   ├── verify-email/page.tsx
│   │   └── set-password/page.tsx
│   ├── (dashboard)/
│   │   ├── layout.tsx          ← AppShell with AuthProvider
│   │   └── dashboard/page.tsx  ← Placeholder dashboard
│   ├── layout.tsx              ← Root layout (unchanged)
│   └── globals.css
├── components/
│   ├── layout/
│   │   ├── app-shell.tsx
│   │   ├── sidebar.tsx
│   │   ├── topbar.tsx
│   │   ├── user-menu.tsx
│   │   └── breadcrumb-nav.tsx
│   ├── shared/
│   │   ├── data-table.tsx
│   │   ├── empty-state.tsx
│   │   ├── error-state.tsx
│   │   ├── confirm-dialog.tsx
│   │   ├── loading-skeleton.tsx
│   │   ├── page-header.tsx
│   │   └── permission-guard.tsx
│   ├── ui/                     ← shadcn v4 components
│   └── theme-provider.tsx
├── config/
│   ├── navigation.ts
│   └── constants.ts
├── hooks/
│   ├── use-current-user.ts
│   ├── use-permission.ts
│   └── use-auth.ts
├── modules/                    ← Ready for business modules
├── providers/
│   └── auth-provider.tsx
├── schemas/
│   └── common.schemas.ts
├── services/
│   ├── api-client.ts
│   └── error-mapper.ts
├── stores/
│   ├── auth.store.ts
│   └── ui.store.ts
├── types/
│   ├── api.types.ts
│   ├── auth.types.ts
│   └── common.types.ts
├── lib/
│   └── utils.ts
└── middleware.ts
```

---

# API Contracts Expected

## Response shape

```json
{
  "success": true,
  "message": "...",
  "data": { ... },
  "meta": { "page": 1, "pageSize": 20, "total": 154, "totalPages": 8 }
}
```

## Error shape

```json
{
  "success": false,
  "message": "...",
  "error": { "code": "ERROR_CODE", "details": { ... } }
}
```

## Auth endpoint used by foundation

- `GET /api/v1/auth/me` — AuthProvider calls this on mount to validate session

---

# Module Structure Convention

Every business module at `src/modules/{module}/` follows:

```text
{module}/
├── components/    ← Module-specific UI
├── hooks/         ← Module-specific hooks
├── services/      ← API calls for this module
├── schemas/       ← Zod schemas for this module
├── types/         ← TypeScript types for this module
└── index.ts       ← Public API barrel export (optional)
```

Module components must not import from other modules directly. Cross-module communication goes through shared stores or props.

---

# Navigation

Sidebar navigation is data-driven via `src/config/navigation.ts`. Modules register their routes as `NavItem` objects:

```typescript
interface NavItem {
  label: string      // Spanish display label
  href: string       // Route path
  icon: LucideIcon   // Lucide icon component
  permission: string | null  // Permission string or null for public
}
```

---

# Dependencies

- Next.js 14.2 (App Router)
- TypeScript 5.7 (strict)
- shadcn/ui v4 (Base UI)
- Zustand 5
- Zod 3
- Lucide React (icons)
- next-themes (dark mode)

---

# Future Changes

When adding a new business module:

1. Create `src/modules/{module}/` with the convention above
2. Add pages under `src/app/(dashboard)/{module}/`
3. Add navigation entry in `src/config/navigation.ts`
4. Add label mapping in `src/components/layout/breadcrumb-nav.tsx`
