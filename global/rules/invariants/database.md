---
description: Database standards for all KOS projects
---

- No ORM — raw SQL with schema files.
- All queries use parameterized placeholders. Never string-interpolate SQL.
- SQLite: WAL mode always enabled.
- All databases at `~/kos-platform/data/db/`. No DB files inside repo directories.
