# skills

Agent identities, skill marketplace, and fleet runtime for KOS multi-agent system.
Four active agents (Atlas, Mercury, Rigby, Syssie) + one ephemeral (Devel).

---

## Key Facts

- Stack: Python 3.12+, uv, PyYAML
- No package install — scripts run directly via `python -m` or subprocess
- Agents run via OpenClaw sessions (WhatsApp/Slack) and launchd consumers
- Fleet consumers are deterministic Python; agents use LLM synthesis

### Agents

| Agent | Role | Key Files |
|-------|------|-----------|
| Atlas | Executive orchestrator | briefing_consumer.py, memory/, SOUL.md |
| Mercury | Email lifecycle | triage/review/closure/policy consumers |
| Rigby | Project management | project_monitor.py, rigby_db.py |
| Syssie | System health | health_engine/, recovery_sweep.py, fleet_event_consumer.py |
| Devel | Build/repair (ephemeral) | Spec-driven, no persistent state |

### Directory Layout

| Directory | Purpose |
|-----------|---------|
| `agents/<name>/` | Agent identity, scripts, consumers |
| `skills/` | Reusable skill modules (19 packages) |
| `fleet/` | Fleet runtime engine (consumer base, pipeline, bus, db) |
| `cron-prompts/` | Scheduled job specifications |
| `config/` | Agent and system configuration |

### Database Access

- fleet/db.py — fleet.db (fleet runtime state)
- agents/rigby/scripts/rigby_db.py — rigby.db (project tracking)
- agents/syssie/health_engine/ — health state (health_system_state.json, health_engine_state.json), ops.db incidents
- All DBs at ~/kos-platform/data/db/

---

## Modification Guardrails

### Safe Without Confirmation
- Bug fixes within existing agent scripts
- Updating cron prompt text
- Adding new skill modules
- Updating health engine spec YAML files

### Requires Confirmation
- Changes to fleet runtime (consumer.py, runtime.py, bus.py)
- New agents or agent identity changes (SOUL.md, AGENTS.md)
- Changes to health engine control loop logic
- Database schema changes (fleet.db, rigby.db)
- Changes to briefing_consumer delivery flow

### Breaking Changes
- Fleet consumer contract changes (affects launchd scheduling)
- Agent identity file format changes (affects OpenClaw loading)
- Health engine spec format changes (affects all 44 component specs)
- Recovery sweep repair logic changes (affects live system safety)
