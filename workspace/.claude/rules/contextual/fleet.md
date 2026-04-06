---
description: Fleet consumer standards
paths: ["**/fleet/**", "**/consumer*"]
---

- All consumers must use `require_single_instance()` flock guard
- Consumers must be idempotent — safe to re-run on failure
- Fleet coordination through `runtime.py` only
