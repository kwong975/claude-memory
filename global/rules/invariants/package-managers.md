---
description: Enforce correct package managers across all projects
---

- Python: always `uv` — `uv add`, `uv run`, `uv sync`. Never `pip install`.
- JS/TS: always `bun` — `bun add`, `bun run`, `bun test`. Never `npm` or `yarn`.
