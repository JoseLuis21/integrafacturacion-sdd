# Environment Rules

Configuration must come from environment variables.

Rules:

- Never hardcode secrets.
- Use environment variables for configuration.
- Provide `.env.example` when introducing new variables.
- Do not commit `.env` files.
- When a variable is missing, add it to `.env.example`.

Secrets include:

- database passwords
- JWT secrets
- API keys
- cloud credentials

---

## Environment Templates

Use the templates in [`templates/env/`](../../templates/env) as reference when setting up new environments:

- `backend.env.example` → Backend environment variables template

Each template includes common variables for that stack. Copy and customize for your environment.
