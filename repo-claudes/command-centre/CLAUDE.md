# Command Centre

AI agent team management — Mission Control for OpenClaw.

---

## Key Facts

- **Frontend:** React 19, TypeScript (strict), Vite 7, Tailwind 4, bun — `:5173` dev / `:8086` prod
- **Backend:** Python 3.12+, FastAPI, uv — `:8087`
- **Integration:** OpenClaw gateway WebSocket RPC at `:18789` (Mac Mini: `100.77.165.99`)
- **DB:** `~/kos-platform/data/db/command.db` — SQLite WAL, **read model only** (not source of truth)
- **Visual identity:** "Dark Ops" — navy-black `#0A0E1A`, accent blue `#3B82F6`
- **Monorepo:** `api/` backend, `src/` frontend

### Architecture Principles

1. **command.db is overlay only.** OpenClaw is authoritative for agents, crons, sessions, chat.
2. **Event adapter layer.** Common schema → ingest from sessions/crons/syssie/threads → read model.
3. **Relationship lines distinguish evidence types.** Observed (solid) vs configured (dashed).
4. **No workspace file editing.** View/inspect only — changes happen in the workspace directly.
5. **Incidents are first-class.** Not derived from events — explicitly created and tracked.

---

## Modification Guardrails

### Safe Without Confirmation
- Frontend component styling and layout changes
- Adding new API query hooks
- Adding filters/sorting to existing views
- Bug fixes in frontend components

### Requires Confirmation
- New backend routes
- Changes to event schema or ingestion logic
- Changes to OpenClaw WebSocket protocol handling
- New database tables or schema migrations
- Adding new npm/pip dependencies

### Breaking Changes
- OpenClaw client protocol changes
- Database schema changes (needs migration strategy)
- API contract changes (frontend depends on response shapes)

---

## Health Platform Ownership

### Data Flow
```
health_engine (Syssie)  → evaluates + recovers + learns
                              ↓
                        writes:
                          - health_system_state.json (canonical public health state)
                          - ops.db incidents (canonical incident truth)
                          - health_engine_history.jsonl (debug/audit)
                              ↓
              /api/health endpoint (gateway liveness for frontend)
                              ↓
              AppHeader.tsx (frontend) — display only, no health derivation
```

### Component Responsibilities

**health_engine** (skills/agents/syssie) — sole health evaluator
- 38 components across 4 tiers, YAML spec-driven
- Deterministic evaluation, recovery, flap detection, stability windows
- Writes incidents to ops.db (canonical) with dedup signatures
- Writes health_system_state.json every cycle (public read model)
- Learning loop generates improvement proposals from incident patterns

**Command Centre** (frontend) — display only
- /api/health returns gateway connectivity status
- AppHeader.tsx shows SYS status dot
- No health derivation, no independent probing
