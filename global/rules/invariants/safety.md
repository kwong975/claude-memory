---
description: Security and secrets handling
---

- No secrets in code. API keys resolve via `~/.config/atlas/credentials.json`.
- Never commit `.env`, `credentials.json`, or files containing tokens/keys.
- Credentials pattern: `credentials.py` reads from JSON, env var override for testing.
