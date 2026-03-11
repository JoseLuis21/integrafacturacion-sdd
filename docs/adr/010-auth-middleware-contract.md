# ADR-010 — Auth middleware validates JWT and injects request auth context

## Context

The SDD repository already defines:

- protected auth endpoints
- JWT/session strategy
- access token examples in login responses

But it did not fully define the transport contract that turns a bearer token into request-scoped identity for protected handlers.

Without that contract, generated backends can issue valid JWTs and still fail on:

- `GET /api/v1/auth/me`
- `POST /api/v1/auth/logout`
- `POST /api/v1/auth/change-password`

because middleware behavior, claims mapping, and unauthorized responses remain ambiguous.

## Decision

JWT access tokens are validated in HTTP middleware.

The middleware is responsible for:

- reading `Authorization: Bearer <access-token>`
- validating JWT signature
- validating issuer
- validating expiration
- extracting identity claims
- injecting `userID`, `email`, and optional `sessionID` into request-scoped context/locals
- returning the standard `UNAUTHORIZED` response when the bearer token is missing or invalid

Handlers and use cases must rely on request context/locals instead of parsing JWT directly.

## Consequences

### Pros

- protected endpoint generation becomes repeatable
- transport/auth concerns stay in the HTTP layer
- handlers stay focused on orchestration and business behavior
- auth contract becomes reusable across modules, not only `auth`

### Cons

- projects must keep middleware contract, claims contract, and issuer configuration aligned
- backends using a different auth transport need an explicit exception in specs or a later ADR
