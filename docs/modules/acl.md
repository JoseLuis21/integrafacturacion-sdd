# Module: ACL

## Purpose

The `acl` module is responsible for authorization through roles and permissions.

This module owns the permissions catalog, the role model, role-to-permission mappings, user-to-role assignments, and effective permission resolution.

---

# Scope

This module includes:

- permissions catalog
- global and company-scoped roles
- role-permission mappings
- user-role assignments
- effective permission resolution
- current-user `can` checks

This module does **not** include:

- authentication
- password lifecycle
- user profile management
- company onboarding logic
- tenant operational data

---

# Canonical Naming

Use `acl` as the canonical module name.

Stable permission codes should follow the existing project style:

- `company.create`
- `company.read`
- `users.create`
- `users.read`
- `acl.role.update`

Use plural REST resources where applicable:

- `/api/v1/acl/roles`
- `/api/v1/acl/permissions`

---

# Actors

- Global Admin
- Company Admin
- Authorized User
- System

---

# Main Entities

## Permission

Represents a stable action that can be granted through a role.

Typical fields:

- id
- code
- module
- action
- scope
- description
- is_system
- created_at
- updated_at

Examples:

- `company.create`
- `company.read`
- `users.create`
- `users.read`
- `acl.role.assign`

Notes:

- permissions are usually seeded and treated as stable platform metadata
- `scope` indicates whether the permission is evaluated globally or within a company context
- `company.create` should be treated as a global permission and checked without `companyId`

---

## Role

Represents a named collection of permissions.

Typical fields:

- id
- company_id
- name
- code
- description
- scope
- status
- is_system
- created_at
- updated_at

Rules:

- company-scoped roles belong to one company
- global roles do not belong to a company
- the seeded `admin` role is global and system-owned
- role `code` must be unique globally for global roles and unique per company for company-scoped roles

---

## RolePermission

Represents the mapping between a role and a permission.

Typical fields:

- id
- role_id
- permission_id
- created_at

---

## UserRoleAssignment

Represents a role assigned to a user.

Typical fields:

- id
- user_id
- role_id
- assigned_by_user_id
- created_at

Notes:

- a company-scoped role assignment is valid only if the user belongs to the same company as the role
- a global role assignment does not require company context

---

# Role Scope Model

The authorization model is primarily company-scoped, with one important exception.

## Global roles

- `admin`

Global role properties:

- no `company_id`
- applies across all companies
- grants all permissions in the catalog
- intended for platform-wide administration

## Company-scoped roles

All non-global roles are company-scoped by default.

Company role properties:

- belong to exactly one company
- may be assigned only to users linked to that company
- affect authorization only within that company context

---

# Admin Bootstrap Policy

The system should seed a reserved global role:

- `admin`

The seeded `admin` role must include every permission in the permissions catalog.

Recommended bootstrap behavior:

1. Seed the permissions catalog.
2. Seed the global `admin` role.
3. Attach all permissions to `admin`.
4. Assign `admin` to the initial platform administrator.

Because you requested that company creators become admins by default, the system should support this policy:

- when a company is created through the privileged bootstrap/onboarding path, ensure the creator holds the global `admin` role

Operational note:

- after bootstrap, company creation is allowed only when the effective permissions of the actor include `company.create`
- by default `company.create` should remain attached only to the seeded global `admin` role

---

# Effective Permission Resolution

Effective permissions are resolved from the roles assigned to a user.

## Resolution rules

- load all global roles assigned to the user
- load all company-scoped roles assigned to the user for the requested company
- union all permissions from those roles
- deduplicate by permission `code`
- return the final set as the effective permissions result

If the user has the global `admin` role:

- the result should include all permissions
- `can` should return `true` for any registered permission

## Membership gate

For company-scoped checks:

- validate that the user belongs to the company
- validate that membership is active
- do not resolve company-scoped roles for users without active membership

---

# API Endpoints

## GET `/api/v1/acl/permissions`

List the permissions catalog.

### Auth required

Yes.

### Suggested filters

- `module`
- `scope`
- `search`

---

## GET `/api/v1/acl/roles`

List roles.

### Suggested filters

- `scope`
- `companyId`
- `status`
- `search`

---

## POST `/api/v1/acl/roles`

Create a role.

### Request

```json
{
  "companyId": "<company-id>",
  "name": "Sales Manager",
  "code": "sales_manager",
  "description": "Manages sales workflow",
  "scope": "company"
}
```

Rules:

- company roles require `companyId`
- global roles should normally be restricted to bootstrap/system flows

---

## GET `/api/v1/acl/roles/:id`

Return role detail.

---

## PATCH `/api/v1/acl/roles/:id`

Update role metadata.

Typical updatable fields:

- `name`
- `description`
- `status`

Do not allow changing:

- `scope`
- `companyId`
- reserved system role identity

unless an explicit change spec later allows it.

---

## GET `/api/v1/acl/roles/:id/permissions`

List permissions attached to a role.

---

## PUT `/api/v1/acl/roles/:id/permissions`

Replace the complete set of permissions assigned to a role.

### Request

```json
{
  "permissionCodes": [
    "users.read",
    "users.create",
    "users.update"
  ]
}
```

Rules:

- permission codes must exist in the catalog
- reserved system roles may be protected from manual edits

---

## GET `/api/v1/acl/users/:userId/roles`

List roles assigned to a user.

### Suggested filters

- `companyId`
- `scope`

---

## POST `/api/v1/acl/users/:userId/roles`

Assign a role to a user.

### Request

```json
{
  "roleId": "<role-id>"
}
```

Rules:

- company-scoped role assignment requires active membership in the role company
- do not duplicate the same role assignment

---

## DELETE `/api/v1/acl/users/:userId/roles/:assignmentId`

Remove a role assignment from a user.

---

## GET `/api/v1/acl/users/:userId/effective-permissions`

Return the deduplicated effective permissions of a user.

### Query params

- `companyId` optional for global-only checks, required for company-scoped resolution

### Response

```json
{
  "success": true,
  "data": {
    "userId": "<user-id>",
    "companyId": "<company-id>",
    "permissions": [
      "users.read",
      "users.create",
      "company.read"
    ]
  }
}
```

Important:

- repeated permissions coming from multiple roles must appear only once

---

## GET `/api/v1/acl/me/permissions`

Return the effective permissions of the current authenticated user.

This endpoint should be available to any authenticated user.

### Query params

- `companyId` optional for global-only checks, required for company-scoped resolution

---

## POST `/api/v1/acl/can`

Return a boolean indicating whether the current authenticated user has a permission.

### Request

```json
{
  "permission": "company.create",
  "companyId": null
}
```

### Response

```json
{
  "success": true,
  "data": {
    "permission": "company.create",
    "companyId": null,
    "can": true
  }
}
```

Rules:

- use current authenticated user from auth middleware
- resolve permissions with deduplication before answering
- for company-scoped checks, validate active company membership
- this endpoint should be available to any authenticated user

---

# Permissions

Suggested ACL permissions:

- `acl.permission.read`
- `acl.role.read`
- `acl.role.create`
- `acl.role.update`
- `acl.role.assign`
- `acl.role.unassign`
- `acl.effective-permissions.read`

Recommended business permissions referenced by other modules:

- `company.create`
- `company.read`
- `company.update`
- `users.read`
- `users.create`
- `users.update`

By default:

- the global `admin` role receives all of them
- `company.create` should be seeded with global scope and reserved to `admin` unless an explicit future policy changes it

---

# Data Ownership

This module belongs to the **control database**.

Tables owned by this module:

- `permissions`
- `roles`
- `role_permissions`
- `user_role_assignments`

Related tables owned by other modules:

- `users` from `user`
- `company_users` from `user`
- `companies` from `company`

This module should **not** store tenant operational data.

---

# Dependencies

The ACL module depends on:

- auth middleware
- users repository
- company memberships from `user`
- companies repository
- audit logger

---

# Security Notes

- Protect ACL endpoints with ACL permissions.
- Restrict creation or editing of global/system roles.
- Validate company membership before assigning company roles.
- Deduplicate effective permissions before returning them.
- Audit every change in roles, role-permission mappings, and assignments.

---

# Error Scenarios

Typical errors include:

- permission not found
- role not found
- assignment not found
- duplicated role code
- duplicated permission code
- duplicated role assignment
- invalid role scope
- invalid company role assignment
- forbidden action
- validation error
- unauthorized session

Suggested stable error codes:

- `PERMISSION_NOT_FOUND`
- `ROLE_NOT_FOUND`
- `ROLE_ASSIGNMENT_NOT_FOUND`
- `ROLE_CODE_ALREADY_EXISTS`
- `PERMISSION_CODE_ALREADY_EXISTS`
- `ROLE_ASSIGNMENT_ALREADY_EXISTS`
- `INVALID_ROLE_SCOPE`
- `INVALID_COMPANY_ROLE_ASSIGNMENT`
- `FORBIDDEN`
- `VALIDATION_ERROR`
- `UNAUTHORIZED`

---

# Frontend Screens

Suggested frontend pages/components:

- permissions catalog page
- roles list page
- role detail page
- role-permissions editor
- user-role assignments panel

Suggested reusable UI pieces:

- permission badge
- role form
- role-permissions form
- user-role assignment form
- permission guard

---

# Backend Structure Suggestion

```text
internal/modules/acl/
├── domain/
│   ├── permission.go
│   ├── role.go
│   ├── role_assignment.go
│   ├── repository.go
│   ├── permission_resolver.go
│   └── errors.go
├── application/
│   ├── create_role.go
│   ├── update_role.go
│   ├── replace_role_permissions.go
│   ├── assign_role_to_user.go
│   ├── remove_role_from_user.go
│   ├── get_effective_permissions.go
│   └── can_use_permission.go
└── infrastructure/
    ├── persistence/
    └── http/
```
