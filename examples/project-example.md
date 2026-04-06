---
workspace: dev
status: active
updated: 2026-04-01
---

# Project: API Rate Limiting

Add rate limiting to the public API to prevent abuse and ensure fair usage across tenants.

## Purpose

Production API has no rate limiting. A single tenant caused a 4-hour outage last month by flooding the endpoint. Need per-tenant limits with configurable thresholds.

## Next

- [ ] Design rate limiting strategy (token bucket vs sliding window)
- [ ] Implement middleware with Redis backing store
- [x] Audit current API endpoints for rate-limit categories
- [ ] Add rate limit headers to responses (X-RateLimit-*)
- [ ] Load test with k6 at 10x expected traffic

## Log

- [2026-04-01] Completed endpoint audit. 3 categories: public (100/min), authenticated (1000/min), admin (unlimited).
- [2026-03-28] Project created after March 15 outage post-mortem.
