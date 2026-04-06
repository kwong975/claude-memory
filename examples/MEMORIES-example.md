# Memories

Learned preferences, calibrations, and corrections.
Updated by Claude during sessions when you state a preference or make a correction.

---

## About You

- **Name:** Alex (they/them). Senior backend engineer at Acme Corp.
- **Decision style:** Prefers options laid out with tradeoffs, not just a single recommendation.
- **Communication:** Direct, concise. Prefers code over prose.
- **Tools:** VS Code, Claude Code, PostgreSQL, Docker.

---

## Working Principles

- **Verify before proposing.** Check whether a problem actually exists before building around it.
- **Ask before assuming.** When requirements are unclear, ask. Don't guess.
- **Minimal footprint.** Solve the problem at hand. Don't build for hypothetical future requirements.

---

## Explicit Calibrations

_How specific situations should be handled._
- **Test database is `test_db` on localhost:5433.** Never point tests at the production database.
- Always run `make lint` before suggesting a PR is ready.

---

## Stated Preferences

_How you prefer things done._
- Use `pnpm` not `npm` for all JS projects.
- Prefer composition over inheritance in Go code.
- Never auto-commit. Always ask first.

---

## Behavioral Corrections

_Persistent adjustments after in-session corrections._
- Don't add defensive nil checks in Go unless the function signature allows nil. Trust the type system.
- Stop summarizing what you just did at the end of every response.
