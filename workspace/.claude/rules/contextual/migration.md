---
description: Database schema migration standards
paths: ["**/schema*", "**/migration*"]
---

- Migrations must be idempotent (use IF NOT EXISTS, etc.)
- New columns must be nullable or have defaults — no breaking existing rows
- Always plan rollback path before applying
