# agent-memory

Canonical memory store for KOS multi-agent system. Ingests, reflects on, and projects
structured memories to all agents with scoped visibility and budget constraints.

---

## Key Facts

- Stack: Python 3.13+, uv, SQLite (WAL, FTS5)
- Owns: agent-memory.db (~/kos-platform/data/db/)
- Pipeline: ingest → reflect → project (runs autonomously every 6h via LaunchAgent)
- Agents served: atlas, rigby, syssie, mercury, devel (budget-constrained per agent)

### Source Layout

| Directory | Purpose |
|-----------|---------|
| `src/agent_memory/ingest/` | Scan memory dirs, classify, deduplicate, store |
| `src/agent_memory/reflection/` | Contradiction resolution, promotion, supersession |
| `src/agent_memory/projection/` | Render USER.md, MEMORY.md, DECISIONS.md per agent |
| `src/agent_memory/storage/` | SQLite layer — memories, entities, FTS5 index |
| `src/agent_memory/importers/` | Legacy import from pre-agent-memory files |

### Database

Core tables: `memories`, `entities`, `memory_entities`, `memory_fts`, `ingest_log`, `reflection_queue`, `reflection_run`, `store_meta`

### Runtime

| Job | Schedule | Purpose |
|-----|----------|---------|
| `ai.agent-memory.cycle` | Every 6h | Full pipeline: ingest → reflect → project |
| `ai.agent-memory.health` | Daily | Health check |

---

## Modification Guardrails

### Safe Without Confirmation
- Bug fixes in pipeline stages
- Updating projection budget thresholds
- Adding new memory type classifications
- Test additions

### Requires Confirmation
- Schema changes to agent-memory.db
- Changes to reflection promotion/supersession logic
- Changes to projection file format (agents consume these)
- Changes to ingest source scanning paths

### Breaking Changes
- Database schema migrations (existing data at risk)
- Projection output format changes (all 5 agents consume)
- Changing memory classification taxonomy
- LaunchAgent schedule changes
