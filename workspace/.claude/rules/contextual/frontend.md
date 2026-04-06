---
description: Frontend component standards
paths: ["**/*.tsx", "**/*.css"]
---

- State completeness: every state a component can be in must be handled (loading, error, empty, data)
- Accessibility: semantic HTML, keyboard navigation, ARIA labels where needed
- No business logic in components — extract to hooks or utilities
