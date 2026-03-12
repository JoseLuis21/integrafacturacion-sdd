# Module: User

## Purpose

The `user` module is responsible for platform user administration and company membership management.

This module owns the lifecycle of users as managed resources in the control layer and coordinates invitation flows with the `auth` module.

---

# Scope

This module includes:

- create or invite users
- list and detail users
- update admin-managed user profile fields
- block and unblock users
- manage memberships between users and companies
- resend invitation flows

This module does **not** include:

- login or logout
- password reset
- email verification execution
- JWT/session lifecycle
- role and permission policy engine
- tenant operational data

---

# Canonical Naming

Use `user` as the canonical module name.

Use plural resource paths in HTTP:

- `/api/v1/users`

Keep `company_users` as the physical control-table name for memberships.

---

# Actors

- Platform Admin
- Company Admin
- Authenticated User with administration permission
- Invited User
- System

---

# Main Entities

## User

Represents a platform account that can authenticate and access one or more companies.

Typical persisted fields:

- id
- email
- email_normalized
- password_hash
- password_set_at
- first_name
- last_name
- phone
- locale
- status
- last_login_at
- created_at
- updated_at

Typical derived/read-model fields:

- full_name
- companies_count
- active_memberships_count

Notes:

- `email_normalized` is the lookup key used across auth and invitation flows
- `full_name` may be computed from `first_name` and `last_name`

---

## CompanyUserMembership

Represents the relationship between a user and a company.

Typical fields:

- id
- user_id
- company_id
- status
- joined_at
- invited_at
- created_at
- updated_at

Recommended membership statuses:

- `invited`
- `active`
- `suspended`

---

# Use Cases

- Create user
- Invite user
- List users
- Get user detail
- Update user
- Block user
- Unblock user
- Resend user invitation
- List company memberships
- Add company membership
- Update company membership
- Activate company membership
- Suspend company membership

---

# Business Rules

- Email must be normalized before uniqueness checks.
- `email_normalized` must be unique.
- Invited users may exist without password set.
- Creating an invited user should request a password setup token from the `auth` module.
- Resend invitation is allowed only for users still awaiting onboarding completion.
- Blocking a user prevents access to tenant-scoped modules.
- A blocked user may remain linked to companies, but active access is denied.
- A user may have memberships in multiple companies.
- Membership must be unique per `(user_id, company_id)`.
- Only membership status `active` grants tenant access.
- Suspending a membership must not delete the user account.
- User creation with memberships should be transactional when possible.

---

# Status Model

## User status

- `invited`
- `active`
- `blocked`
- `pending_email_verification`

## Company membership status

- `invited`
- `active`
- `suspended`

---

# Invitation Flow Contract

The `user` module owns the decision to invite a user, but the `auth` module owns password setup tokens and related mail templates.

Suggested invitation flow:

1. Validate actor permissions.
2. Normalize and validate email.
3. Create or reuse the user record in invitation-compatible state.
4. Create one or more company memberships.
5. Request password setup token creation from `auth`.
6. Trigger invitation email through the auth mail flow.

If the user already exists:

- do not duplicate the account
- allow adding a new membership if the `(user_id, company_id)` relation does not exist
- avoid resending setup flow unless business policy explicitly allows it

---

# API Endpoints

## POST `/api/v1/users`

Create or invite a user.

### Auth required

Yes. Use `Authorization: Bearer <access-token>`.

### Request

```json
{
  "email": "equipo@demo.cl",
  "firstName": "Ana",
  "lastName": "Pérez",
  "phone": "+56 9 1234 5678",
  "locale": "es-CL",
  "sendInvitation": true,
  "memberships": [
    {
      "companyId": "<company-id>",
      "status": "invited"
    }
  ]
}
```

### Response

```json
{
  "success": true,
  "data": {
    "id": "<user-id>",
    "email": "equipo@demo.cl",
    "status": "invited",
    "membershipsCreated": 1
  }
}
```

---

## GET `/api/v1/users`

List users.

### Suggested filters

- `status`
- `email`
- `companyId`
- `search`

---

## GET `/api/v1/users/:id`

Return user detail with memberships summary.

---

## PATCH `/api/v1/users/:id`

Update admin-managed user fields.

Typical updatable fields:

- `firstName`
- `lastName`
- `phone`
- `locale`

Do not allow patching:

- `email`
- `emailNormalized`
- `passwordHash`

unless an explicit change spec later allows it.

---

## POST `/api/v1/users/:id/block`

Set user status to `blocked`.

Blocking should revoke effective tenant access even if memberships stay active.

---

## POST `/api/v1/users/:id/unblock`

Move a blocked user back to an allowed status according to business policy.

Suggested behavior:

- restore to `active` if onboarding is complete
- restore to `pending_email_verification` if email is still not verified

---

## POST `/api/v1/users/:id/resend-invitation`

Resend setup/invitation email through the `auth` mail flow.

Suggested restrictions:

- user status is `invited` or `pending_email_verification`
- password has not been set yet

---

## GET `/api/v1/users/:id/company-memberships`

List memberships for a user.

---

## POST `/api/v1/users/:id/company-memberships`

Add a company membership to a user.

### Request

```json
{
  "companyId": "<company-id>",
  "status": "invited"
}
```

---

## PATCH `/api/v1/users/:id/company-memberships/:membershipId`

Update membership fields.

Typical updatable fields:

- `status`

---

## POST `/api/v1/users/:id/company-memberships/:membershipId/activate`

Set membership status to `active`.

---

## POST `/api/v1/users/:id/company-memberships/:membershipId/suspend`

Set membership status to `suspended`.

---

# Permissions

Suggested permissions:

- `users.read`
- `users.create`
- `users.update`
- `users.block`
- `users.unblock`
- `users.invite`
- `company_users.read`
- `company_users.create`
- `company_users.update`

---

# Data Ownership

This module belongs to the **control database**.

Tables owned by this module:

- `users`
- `company_users`

Related tables owned by other modules:

- `email_verifications` from `auth`
- `password_setup_tokens` from `auth`
- `password_reset_tokens` from `auth`
- `companies` from `company`

This module should **not** store tenant operational data.

---

# Dependencies

The user module depends on:

- auth middleware
- auth password-setup flow
- auth mail delivery contract
- companies repository
- email normalization
- audit logger

---

# Security Notes

- Restrict user creation, blocking, and membership changes to authorized actors.
- Do not leak whether an email has completed onboarding when the actor is not authorized to know.
- Never store raw password setup tokens in this module.
- Audit membership and status changes.

---

# Error Scenarios

Typical errors include:

- duplicated email
- user not found
- company not found
- duplicated membership
- invalid user status transition
- invalid membership status transition
- invitation not allowed
- forbidden action
- validation error
- unauthorized session

Suggested stable error codes:

- `EMAIL_ALREADY_EXISTS`
- `USER_NOT_FOUND`
- `COMPANY_NOT_FOUND`
- `MEMBERSHIP_ALREADY_EXISTS`
- `MEMBERSHIP_NOT_FOUND`
- `INVALID_USER_STATUS`
- `INVALID_MEMBERSHIP_STATUS`
- `INVITATION_NOT_ALLOWED`
- `FORBIDDEN`
- `VALIDATION_ERROR`
- `UNAUTHORIZED`

---

# Frontend Screens

Suggested frontend pages/components:

- users list page
- create/invite user page
- user detail page
- user memberships tab
- block/unblock action controls

Suggested reusable UI pieces:

- user form
- invite user form
- user status badge
- membership form
- membership list

---

# Backend Structure Suggestion

```text
internal/modules/user/
├── domain/
│   ├── user.go
│   ├── company_membership.go
│   ├── repository.go
│   ├── invitation_dispatcher.go
│   ├── errors.go
│   └── value_objects/
│       └── email.go
├── application/
│   ├── create_user.go
│   ├── invite_user.go
│   ├── update_user.go
│   ├── block_user.go
│   ├── unblock_user.go
│   ├── add_company_membership.go
│   └── resend_invitation.go
└── infrastructure/
    ├── persistence/
    └── http/
```

