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
- Users without password set cannot login with password flow.
- Passwords are stored only as secure hashes.
- Verification and reset tokens must expire.
- Verification and reset tokens must be one-time use.
- Login should update last_login_at.
- Auth module belongs to control DB, not tenant DB.
- Auth does not grant business access by itself; access still depends on company membership and ACL.

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

## Security Notes

- Never store raw passwords.
- Never store raw reset or verification tokens in DB.
- Add rate limiting to login and forgot-password.
- Do not reveal sensitive account existence details in forgot-password flow.
- Authenticated session is required for /auth/me and /auth/change-password.
