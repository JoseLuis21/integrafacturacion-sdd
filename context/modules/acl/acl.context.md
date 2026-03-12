# ACL Module Context

## Purpose

ACL handles authorization through roles and permissions.

It is the canonical module for defining permissions, creating roles, assigning roles to users, resolving effective permissions, and answering permission checks.

## Core Use Cases

- List permissions catalog
- List roles
- Create company-scoped role
- Update role
- Replace role permissions
- Assign role to user
- Remove role assignment from user
- List effective permissions for user
- Check `can` for current user

## Main Entities

- Permission
- Role
- RolePermission
- UserRoleAssignment

## Key Rules

- Use `acl` as the canonical module name.
- Permissions are identified by stable codes like `company.create` or `users.read`.
- The global `admin` role is seeded by default.
- The global `admin` role has every permission in the permissions catalog.
- Only users with effective permission `company.create` can create companies.
- `company.create` is evaluated as a global permission without company context.
- By default, `company.create` is granted through the global `admin` role.
- Roles are company-scoped by default.
- Only the `admin` role is global by default.
- Role `code` must be unique globally for global roles and unique per company for company-scoped roles.
- A user can belong to many companies and can hold different company roles in each one.
- Company-scoped roles can only be assigned if the user belongs to the same company.
- Effective permissions are the union of permissions granted by all assigned roles.
- Effective permission listing must deduplicate repeated permissions by code.
- `can` returns a boolean for the current authenticated user and permission code.

## Main Endpoints

- GET /api/v1/acl/permissions
- GET /api/v1/acl/roles
- POST /api/v1/acl/roles
- GET /api/v1/acl/roles/:id
- PATCH /api/v1/acl/roles/:id
- GET /api/v1/acl/roles/:id/permissions
- PUT /api/v1/acl/roles/:id/permissions
- GET /api/v1/acl/users/:userId/roles
- POST /api/v1/acl/users/:userId/roles
- DELETE /api/v1/acl/users/:userId/roles/:assignmentId
- GET /api/v1/acl/users/:userId/effective-permissions
- GET /api/v1/acl/me/permissions
- POST /api/v1/acl/can

## Dependencies

- users
- companies
- company_users
- auth middleware
- audit logger

## Security Notes

- Protect ACL management endpoints with ACL permissions.
- Prevent editing reserved system roles unless explicitly allowed.
- Never resolve company-scoped permissions without validating company membership.
- Audit role changes, permission changes, and assignments.

## Frontend Implementation

### Module Location

`src/modules/acl/` in the frontend repository.

### Suggested Structure

```text
src/modules/acl/
├── services/acl.service.ts
├── schemas/
│   ├── role.schema.ts
│   ├── role-permissions.schema.ts
│   └── can.schema.ts
├── hooks/
│   ├── use-permissions.ts
│   ├── use-roles.ts
│   ├── use-role.ts
│   ├── use-user-effective-permissions.ts
│   └── use-can.ts
└── components/
    ├── role-form.tsx
    ├── role-permissions-form.tsx
    ├── permission-badge.tsx
    ├── user-role-assignment-form.tsx
    └── permission-guard.tsx
```
