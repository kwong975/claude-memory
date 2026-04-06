---
description: Python development standards
paths: ["**/*.py"]
---

- Linting: `ruff check` + `ruff format`
- Tests: `uv run pytest`
- No ORM — raw SQL with schema files
- Type hints on public APIs
