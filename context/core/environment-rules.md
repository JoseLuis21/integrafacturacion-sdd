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

Use the template in [`templates/project/backend/.env.example`](../../templates/project/backend/.env.example) as reference when setting up new environments.

Copy and customize for your environment. Include all required variables from the template:

- APP configuration (name, env, port)
- DATABASE (host, port, credentials, name)
- JWT settings
- MAIL provider settings
- STORAGE provider settings
