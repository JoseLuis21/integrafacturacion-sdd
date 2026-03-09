# Change: Auth Google OAuth

## Affected Module
auth

## Purpose
Add Google OAuth as an authentication option without breaking the current email/password flow.

## Why This Change Exists
Users may want faster login and easier account access using Google. This change should allow OAuth login while preserving the existing auth model.

## New Use Cases
- Start Google login
- Handle Google callback
- Login with Google
- Link Google account to existing user
- Unlink Google account if policy allows

## Business Rules
- Google email must be verified by Google provider.
- Blocked users cannot login through Google.
- If a user already exists by normalized email, the Google account should be linked instead of creating a duplicate account, if policy allows.
- If no user exists, the system may create a new user automatically depending on product policy.
- OAuth provider identity must be stored separately from user password credentials.
- Existing password login must continue working.
- Invited users may complete account access through Google only if business policy allows it.
- Callback flow must validate `state` to prevent CSRF.
- Provider tokens should not be stored unless strictly needed.
- If refresh/access tokens from provider are stored, they must be stored securely.

## New Data Required
New table suggested:
- oauth_accounts

Suggested fields:
- id
- user_id
- provider
- provider_user_id
- provider_email
- provider_email_verified
- created_at
- updated_at

## API Changes
- GET /api/v1/auth/google/start
- GET /api/v1/auth/google/callback
- POST /api/v1/auth/google/link
- DELETE /api/v1/auth/google/unlink

## UI Changes
- Add "Continue with Google" button on login page
- Add Google callback handling page
- Optional account linking UI in profile/security page

## Security Notes
- Validate OAuth state
- Validate provider-issued identity token or userinfo properly
- Do not trust email without provider verification
- Keep password login flow intact
- Audit login source (password vs google)

## Backend Impact
- auth module
- new oauth provider adapter
- new oauth account repository/model
- token/session handling after provider callback

## Frontend Impact
- login page
- auth service
- callback route/page
- optional profile linking management

## Testing
- should start google auth flow
- should reject invalid callback state
- should login existing linked user
- should link existing user by normalized email when policy allows
- should block blocked users
- should create new user when policy allows
