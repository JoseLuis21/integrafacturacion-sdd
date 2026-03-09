# Auth Module Context

## Purpose

Auth handles authentication and account access for platform users.

## Core Use Cases

- Login with email and password
- Logout current session
- Get current authenticated profile
- Verify email
- Resend verify email
- Set password for invited user
- Request password reset
- Reset password
- Change password

## Main Entities

- User
- CompanyUser
- EmailVerification
- PasswordSetupToken
- PasswordResetToken

## Key Rules

- Email must be normalized before lookup.
- Blocked users cannot login.
- Invited users cannot login with password until the first password is set.
- Pending email verification users cannot login with password until email is verified.
- Passwords are stored only as secure hashes.
- Email verification tokens expire in 24 hours and are one-time use.
- Password setup tokens expire in 72 hours and are one-time use.
- Password reset tokens expire in 1 hour and are one-time use.
- Login updates `last_login_at`.
- Login may succeed without company membership, but tenant access requires at least one active company membership.
- Authenticated endpoints require middleware to inject `userID` and `sessionID` into request context.
- Logout revokes the current refresh token/session.
- Forgot-password must not reveal whether the account exists.

## Main Endpoints

- POST /api/v1/auth/login
- POST /api/v1/auth/logout
- GET /api/v1/auth/me
- POST /api/v1/auth/verify-email
- POST /api/v1/auth/resend-verify-email
- POST /api/v1/auth/set-password
- POST /api/v1/auth/forgot-password
- POST /api/v1/auth/reset-password
- POST /api/v1/auth/change-password

## Dependencies

- users
- company_users
- email_verifications
- password_setup_tokens
- password_reset_tokens
- JWT/session provider
- password hasher
- token generator
- mailer

## Session Notes

- Auth uses JWT access tokens plus persisted refresh tokens.
- Access token ttl: 60 minutes.
- Refresh token ttl: 30 days.

---

## Security Notes

- Never store raw passwords.
- Never store raw verification, setup, or reset tokens.
- Apply rate limiting to login and forgot-password.
- Audit successful and failed login attempts.

---

## Frontend Implementation

### Module Location

`src/modules/auth/` in the `integrafacturacion` (frontend) repository.

### Structure

```
src/modules/auth/
├── services/auth.service.ts       — 9 typed API functions over apiClient
├── schemas/
│   ├── login.schema.ts            — email + password (Zod)
│   ├── forgot-password.schema.ts  — email only
│   ├── reset-password.schema.ts   — token + password + confirmation
│   ├── set-password.schema.ts     — token + password + confirmation
│   └── change-password.schema.ts  — currentPassword + newPassword + confirmation
├── hooks/
│   ├── use-login.ts               — login → cookie + store + redirect /dashboard
│   ├── use-logout.ts              — POST /logout → clear state → redirect /login
│   ├── use-forgot-password.ts     — always shows generic success (security)
│   ├── use-reset-password.ts      — reset → success toast → redirect /login
│   ├── use-set-password.ts        — set → success toast → redirect /login
│   ├── use-change-password.ts     — requires auth session
│   └── use-verify-email.ts        — auto-triggers on mount, token from URL
└── components/
    ├── login-form.tsx
    ├── forgot-password-form.tsx
    ├── reset-password-form.tsx
    ├── set-password-form.tsx
    └── change-password-form.tsx
```

### Pages

- `src/app/(auth)/login/` → LoginForm
- `src/app/(auth)/forgot-password/` → ForgotPasswordForm
- `src/app/(auth)/reset-password/?token=X` → ResetPasswordForm (server component extracts token)
- `src/app/(auth)/set-password/?token=X` → SetPasswordForm (server component extracts token)
- `src/app/(auth)/verify-email/?token=X` → useVerifyEmail auto-trigger (client component)
- `src/app/(dashboard)/settings/change-password/` → ChangePasswordForm (authenticated)

### Key Patterns

- Forms use react-hook-form + zodResolver for validation
- Hooks own side effects: API call → store update → navigation → error mapping
- Service layer is a thin typed wrapper over apiClient (no business logic)
- Error codes mapped to Spanish messages via error-mapper
- Forgot-password never reveals if email exists (security requirement)
- Token-based pages show error state if token is missing from URL
- Auth token stored in cookie (auth-token, path=/, SameSite=Lax) for middleware SSR compatibility
