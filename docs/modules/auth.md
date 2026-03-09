# Module: Auth

## Purpose

The `auth` module is responsible for user authentication and account access to the platform.

Its goal is to allow users to:

- authenticate with email and password
- access their current session/profile
- verify email
- set or reset password
- change password once authenticated
- logout safely

This module belongs to the **control layer** of the system and is not part of tenant operational data.

---

# Scope

This module includes:

- login
- logout
- current authenticated user
- email verification
- resend email verification
- invitation password setup
- forgot password
- reset password
- change password

This module does **not** include:

- business permissions/ACL management
- tenant resolution
- role administration
- API key management
- social login providers unless added through a change spec
- MFA unless added through a change spec

---

# Actors

- User
- Invited User
- Authenticated User
- System
- Admin (indirectly, through user creation/invitation flows in other modules)

---

# Main Entities

## User

Represents a platform user account.

Typical fields:

- id
- email
- email_normalized
- password_hash
- password_set_at
- first_name
- last_name
- full_name
- phone
- locale
- status
- last_login_at
- created_at
- updated_at

---

## CompanyUser

Represents the relationship between a user and a company/workspace.

Typical fields:

- id
- user_id
- company_id
- status
- joined_at
- invited_at

---

## EmailVerification

Represents verification tokens used to confirm email ownership.

Typical fields:

- id
- user_id
- email
- token_hash
- expires_at
- verified_at
- consumed_at
- created_at

---

## PasswordSetupToken

Represents one-time tokens used by invited users to set their first password.

Typical fields:

- id
- user_id
- token_hash
- expires_at
- used_at
- created_at

---

## PasswordResetToken

Represents one-time tokens used to reset a password.

Typical fields:

- id
- user_id
- token_hash
- expires_at
- used_at
- requested_ip
- created_at

---

# Use Cases

- Login
- Logout
- Get current profile
- Verify email
- Resend verify email
- Set password for invited user
- Request password reset
- Reset password with token
- Change password

---

# Business Rules

- Email must be normalized before lookup.
- Login must use normalized email for matching.
- Blocked users cannot login.
- Users without a password set cannot login using the password flow.
- Passwords must be stored only as secure hashes.
- Email verification tokens must expire.
- Email verification tokens must be one-time use.
- Password setup tokens must expire.
- Password setup tokens must be one-time use.
- Password reset tokens must expire.
- Password reset tokens must be one-time use.
- Successful login updates `last_login_at`.
- A user must belong to at least one company to access tenant data.
- Forgot-password flow should not reveal sensitive account existence details.
- Change-password flow requires an authenticated session.
- Logout must invalidate the current session or refresh token strategy if applicable.

---

# Module States / User Status

Suggested user statuses:

- `invited`
- `active`
- `blocked`
- `pending_email_verification`

### Rules by status

#### invited

- may exist without password set
- cannot login with password until password is set

#### active

- can login if credentials are valid

#### blocked

- cannot login
- cannot use password auth flow

#### pending_email_verification

- cannot complete password login until email is verified
- may request resend verification email
- may verify email using a valid token

---

# API Endpoints

---

# Session Strategy

Authentication uses:

- short-lived JWT access tokens
- refresh tokens persisted in the control database

## Rules

- access token is returned by `POST /api/v1/auth/login`
- refresh token may be returned as an HTTP-only cookie or response field depending on API policy
- logout invalidates the current refresh token/session
- access tokens are not persisted server-side
- multiple concurrent sessions are allowed unless revoked explicitly

## Suggested defaults

- access token ttl: 60 minutes
- refresh token ttl: 30 days

---

# Auth Middleware Contract

Authenticated endpoints depend on middleware that validates the access token and injects request-scoped auth data.

## Middleware output

The middleware must make available:

- `userID`
- `sessionID` if refresh/session persistence is used
- `email`
- optional `companyID` if tenant context was already selected

## JWT claims

Suggested claims:

- `sub` → user id
- `sid` → session id
- `eml` → email
- `iss` → issuer
- `iat` → issued at
- `exp` → expiration

---

# Password Policy

Passwords must satisfy:

- minimum length: 8
- at least 1 uppercase letter
- at least 1 lowercase letter
- at least 1 number
- at least 1 symbol

Validation errors should return:

- `VALIDATION_ERROR`

---

# Token Policies

## Email verification token

- one-time use
- expires in 24 hours

## Password setup token

- one-time use
- expires in 72 hours

## Password reset token

- one-time use
- expires in 1 hour

## Access token

- expires in 60 minutes

## Refresh token

- expires in 30 days
- revoked on logout

---

# Company Membership Access Policy

- login may succeed even if the user has zero active company memberships
- access to tenant-scoped modules requires at least one active company membership
- only `company_users.status = active` grants tenant access
- invited or suspended memberships do not grant tenant access

---

# Rate Limiting

Apply rate limiting to:

## POST /api/v1/auth/login

- limit by IP: 10 requests per 5 minutes
- limit by normalized email: 5 failed attempts per 15 minutes

## POST /api/v1/auth/forgot-password

- limit by IP: 5 requests per 15 minutes
- limit by normalized email: 3 requests per 30 minutes

Rate-limited responses return:

- HTTP 429
- code: `RATE_LIMITED`

---

# Audit Rules

Audit these events:

- login_succeeded
- login_failed
- logout_succeeded
- password_reset_requested
- password_reset_completed
- password_changed
- email_verified

Each audit event should include:

- user_id if known
- normalized email if relevant
- ip
- result
- error_code if failed
- created_at

---

# Mail Delivery Contract

Auth mail flows:

- email verification
- password reset
- invitation password setup

## Required template keys

- `auth.verify-email`
- `auth.reset-password`
- `auth.set-password`

## Link format

- verify email: `{frontendBaseURL}/verify-email?token={token}`
- reset password: `{frontendBaseURL}/reset-password?token={token}`
- set password: `{frontendBaseURL}/set-password?token={token}`

---

# Error Mapping

| Code                     | HTTP Status | Meaning                                  |
| ------------------------ | ----------- | ---------------------------------------- |
| INVALID_CREDENTIALS      | 401         | email/password mismatch                  |
| USER_BLOCKED             | 403         | blocked user cannot authenticate         |
| PASSWORD_NOT_SET         | 403         | invited user has no password yet         |
| UNAUTHORIZED             | 401         | missing or invalid authenticated session |
| INVALID_CURRENT_PASSWORD | 422         | current password does not match          |
| TOKEN_EXPIRED            | 422         | token expired                            |
| TOKEN_ALREADY_USED       | 422         | token already consumed                   |
| VALIDATION_ERROR         | 400         | invalid input                            |
| RATE_LIMITED             | 429         | request limit exceeded                   |

---

# Password Setup Token Creation Contract

Password setup tokens are created outside the public auth endpoints.

## Owner

- created by the user invitation flow in the users/company-users module

## Delivery

- delivered by email through the auth mailer contract

## Expiration

- expires in 72 hours

---

# API Endpoints

## POST `/api/v1/auth/login`

Authenticate a user with email and password.

### Request

```json
{
  "email": "user@example.com",
  "password": "Secret123!"
}
```

### Response

```json
{
  "success": true,
  "data": {
    "id": "018f....",
    "email": "user@example.com",
    "fullName": "Jane Doe",
    "status": "active",
    "companies": [
      {
        "id": "018f....",
        "name": "AirConnect",
        "slug": "airconnect"
      }
    ],
    "accessToken": "jwt-token"
  }
}
```

---

## POST `/api/v1/auth/logout`

Invalidate the current authenticated session.

### Auth required

Yes

---

## GET `/api/v1/auth/me`

Return the current authenticated user profile.

### Auth required

Yes

### Response

```json
{
  "success": true,
  "data": {
    "id": "018f....",
    "email": "user@example.com",
    "fullName": "Jane Doe",
    "status": "active",
    "emailVerified": true,
    "companies": [
      {
        "id": "018f....",
        "name": "AirConnect",
        "slug": "airconnect"
      }
    ]
  }
}
```

---

## POST `/api/v1/auth/verify-email`

Verify an email token.

### Request

```json
{
  "token": "raw-token"
}
```

---

## POST `/api/v1/auth/resend-verify-email`

Resend a verification email.

### Request

```json
{
  "email": "user@example.com"
}
```

---

## POST `/api/v1/auth/set-password`

Set the first password for an invited user.

### Request

```json
{
  "token": "raw-token",
  "password": "Secret123!",
  "passwordConfirmation": "Secret123!"
}
```

---

## POST `/api/v1/auth/forgot-password`

Request a password reset.

### Request

```json
{
  "email": "user@example.com"
}
```

---

## POST `/api/v1/auth/reset-password`

Reset a password using a valid token.

### Request

```json
{
  "token": "raw-token",
  "password": "Secret123!",
  "passwordConfirmation": "Secret123!"
}
```

---

## POST `/api/v1/auth/change-password`

Change password for the current authenticated user.

### Auth required

Yes

### Request

```json
{
  "currentPassword": "OldSecret123!",
  "newPassword": "NewSecret123!",
  "newPasswordConfirmation": "NewSecret123!"
}
```

---

# Permissions

This module usually does not require business permissions for public auth flows:

- login
- forgot password
- reset password
- verify email
- set password

Authenticated profile access can use:

- `auth.me`

Other user-management permissions belong to other modules, such as:

- `users.read`
- `users.create`
- `users.update`

---

# Data Ownership

This module belongs to the **control database**.

Tables typically used:

- `users`
- `company_users`
- `email_verifications`
- `password_setup_tokens`
- `password_reset_tokens`

Optional supporting tables:

- `refresh_tokens`
- `login_audit_logs`

This module should **not** store tenant operational data.

---

# Dependencies

The auth module depends on:

- user repository
- company-user repository
- password hasher
- token generator
- session/JWT provider
- mailer provider
- optional audit logger
- optional refresh token repository

---

# Security Notes

- Never store raw passwords.
- Never store raw reset or verification tokens in the database.
- Store only token hashes.
- Apply rate limiting to login and forgot-password endpoints.
- Avoid leaking sensitive user existence information.
- Make session invalidation strategy explicit.
- Validate password policy consistently.
- Audit successful and failed login attempts when possible.

---

# Error Scenarios

Typical errors include:

- invalid credentials
- blocked user
- password not set
- expired token
- consumed token
- unauthorized session
- invalid current password
- password confirmation mismatch

Suggested stable error codes:

- `INVALID_CREDENTIALS`
- `USER_BLOCKED`
- `PASSWORD_NOT_SET`
- `TOKEN_EXPIRED`
- `TOKEN_ALREADY_USED`
- `UNAUTHORIZED`
- `INVALID_CURRENT_PASSWORD`
- `VALIDATION_ERROR`

---

# Frontend Screens

Suggested frontend pages/components:

- login page
- forgot password page
- reset password page
- verify email page
- set password page
- profile page
- change password form

Suggested reusable UI pieces:

- login form
- forgot password form
- reset password form
- set password form
- change password form

---

# Backend Structure Suggestion

```text
internal/modules/auth/
├── domain/
│   ├── user_session.go
│   ├── repository.go
│   ├── errors.go
│   └── password_policy.go
├── application/
│   ├── dto/
│   │   ├── login_input.go
│   │   ├── login_output.go
│   │   ├── forgot_password_input.go
│   │   ├── reset_password_input.go
│   │   └── me_output.go
│   └── usecases/
│       ├── login.go
│       ├── logout.go
│       ├── get_current_user.go
│       ├── verify_email.go
│       ├── resend_verify_email.go
│       ├── set_password.go
│       ├── forgot_password.go
│       ├── reset_password.go
│       └── change_password.go
├── infrastructure/
│   ├── persistence/postgres/
│   │   ├── user_repository.go
│   │   ├── token_repository.go
│   │   └── models.go
│   ├── http/
│   │   ├── handler.go
│   │   ├── request.go
│   │   ├── response.go
│   │   └── routes.go
│   └── providers/
│       ├── password_hasher.go
│       ├── token_generator.go
│       └── mailer.go
└── module.go
```

---

# Frontend Structure Suggestion

```text
src/modules/auth/
├── components/
│   ├── login-form.tsx
│   ├── forgot-password-form.tsx
│   ├── reset-password-form.tsx
│   ├── set-password-form.tsx
│   └── change-password-form.tsx
├── hooks/
│   ├── use-login.ts
│   ├── use-logout.ts
│   ├── use-current-user.ts
│   ├── use-forgot-password.ts
│   ├── use-reset-password.ts
│   └── use-change-password.ts
├── services/
│   └── auth.service.ts
├── schemas/
│   ├── login.schema.ts
│   ├── forgot-password.schema.ts
│   ├── reset-password.schema.ts
│   └── change-password.schema.ts
├── types/
│   └── auth.types.ts
└── pages/
    ├── login-page.tsx
    ├── forgot-password-page.tsx
    ├── reset-password-page.tsx
    ├── verify-email-page.tsx
    └── set-password-page.tsx
```

---

# Testing Guidelines

## Backend

Cover at least:

- successful login
- blocked user login rejection
- password not set rejection
- verify email success
- verify email expired token
- set password success
- set password used token
- forgot password request
- reset password success
- reset password expired token
- change password success
- invalid current password

## Frontend

Cover at least:

- login form validation
- forgot password form validation
- reset password form validation
- submit loading state
- success and error rendering

---

# Future Changes

Future capabilities should be added through **change specs**, not by silently stretching the module.

Examples:

- Google OAuth
- MFA
- magic links
- SSO / SAML
- device/session management

These should be modeled in:

- `docs/changes/...`
- `specs/modules/auth/changes/...`

and later consolidated into the main auth spec if accepted.
