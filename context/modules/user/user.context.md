# User Module Context

## Purpose

User handles platform user administration and company membership management.

It is the canonical module for creating, inviting, updating, and blocking users in the control layer.

## Core Use Cases

- Create or invite user
- List users
- Get user detail
- Update user profile and admin-managed fields
- Block or unblock user
- List company memberships for a user
- Add company membership
- Activate or suspend company membership
- Resend invitation for invited user

## Main Entities

- User
- CompanyUserMembership

## Key Rules

- Use `user` as the canonical module name and `users` as the HTTP resource path.
- User master data belongs to the control database.
- Email must be normalized and validated before persistence.
- `email_normalized` must be unique.
- Invited users may exist without password set.
- User invitation should create or request a password setup token through the auth module.
- A user may belong to multiple companies.
- A company membership must be unique per `(user_id, company_id)`.
- Only membership status `active` grants tenant access.
- Blocked users cannot access tenant-scoped modules even if memberships are active.
- Resend invitation is allowed only for users who are still in invitation/onboarding state.

## Main Endpoints

- POST /api/v1/users
- GET /api/v1/users
- GET /api/v1/users/:id
- PATCH /api/v1/users/:id
- POST /api/v1/users/:id/block
- POST /api/v1/users/:id/unblock
- POST /api/v1/users/:id/resend-invitation
- GET /api/v1/users/:id/company-memberships
- POST /api/v1/users/:id/company-memberships
- PATCH /api/v1/users/:id/company-memberships/:membershipId
- POST /api/v1/users/:id/company-memberships/:membershipId/activate
- POST /api/v1/users/:id/company-memberships/:membershipId/suspend

## Dependencies

- companies
- auth invitation/password-setup flow
- auth mail delivery
- email normalizer
- audit logger

## Security Notes

- Restrict user creation and membership changes to authorized actors.
- Do not expose blocked or invited-only actions to unauthorized company members.
- Audit user creation, blocking, unblocking, invitation resend, and membership changes.
- Never store raw invitation tokens in this module.

## Frontend Implementation

### Module Location

`src/modules/user/` in the frontend repository.

### Suggested Structure

```text
src/modules/user/
├── services/user.service.ts
├── schemas/
│   ├── user.schema.ts
│   ├── invite-user.schema.ts
│   └── membership.schema.ts
├── hooks/
│   ├── use-users.ts
│   ├── use-user.ts
│   ├── use-create-user.ts
│   ├── use-update-user.ts
│   ├── use-block-user.ts
│   ├── use-user-memberships.ts
│   └── use-resend-user-invitation.ts
└── components/
    ├── user-form.tsx
    ├── user-status-badge.tsx
    ├── invite-user-form.tsx
    ├── membership-form.tsx
    └── membership-list.tsx
```

### Suggested Pages

- `src/app/(dashboard)/users/`
- `src/app/(dashboard)/users/new/`
- `src/app/(dashboard)/users/[userId]/`
- `src/app/(dashboard)/users/[userId]/memberships/`

