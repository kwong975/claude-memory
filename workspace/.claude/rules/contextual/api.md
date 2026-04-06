---
description: API route standards
paths: ["**/api/**", "**/routes/**"]
---

- Routers are thin — validation + dispatch only, no business logic
- Validate all external input at the boundary
- Return consistent error shapes
