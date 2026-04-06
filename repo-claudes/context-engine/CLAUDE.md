# context-engine

Executive attention and accountability system. Ingests meetings and emails,
resolves them into matters and threads, tracks commitments, surfaces attention,
and produces daily briefings.

---

## Key Facts

- Stack: Python 3.12+, uv, SQLite (WAL)
- Repo: context-engine (package: context_engine)
- Owns: atlas.db (~/kos-platform/data/db/atlas.db)
- Reads: knowledge.db (data-layer-owned, ~/kos-platform/data/db/)
- Imported by: command-centre (schema.get_connection)
- Called by: briefing_consumer (CLI), finalization.py (subprocess), launchd jobs

### Modules

| Module | Purpose |
|--------|---------|
| `schema.py` | Atlas DB schema (18 tables), connections, migrations |
| `ingest.py` | Unified ingestion: `ingest_meeting()`, `ingest_email()` |
| `pipeline/` | 5-stage pipeline: capture → normalize → interpret → resolve → commit |
| `interpret/` | Deterministic grammar and entity extraction |
| `lifecycle.py` | Daily lifecycle: overdue, stale, auto-resolve, health_state, attention_score |
| `read.py` | Attention engine, daily/weekly surfaces, query layer |
| `crud.py` | 16-operation operator repair toolkit |
| `compat.py` | Morning briefing + evening close output |
| `meeting_prep.py` | Meeting prep context assembly |
| `identity/` | Person resolution and taxonomy |
| `enrich.py` | Participant enrichment from vault frontmatter |
| `live_ingest.py` | Catch-up ingestion for new meetings |
| `backfill.py` | Meeting + email backfill from source systems |
| `seed.py` | People seeding from taxonomy.yaml |
| `validate.py` | Post-backfill validation |
| `db.py` | DB path resolution |
| `utils.py` | Shared utilities (timestamps, UUIDs) |

### Database

| Database | Role |
|----------|------|
| atlas.db | **Owns** — 18 tables, all writes |
| knowledge.db | Reads — meeting notes, actions |

All databases at `~/kos-platform/data/db/`. No DB files inside this repo.

### Runtime (launchd on Mini)

| Job | Schedule | Command |
|-----|----------|---------|
| `ai.context-engine.lifecycle` | Daily 5:50am | `python -m context_engine.lifecycle` |
| `ai.context-engine.ingest` | Every 15min | `python -m context_engine.live_ingest` |
| `ai.atlas.briefing` | Every 30min | `briefing_consumer.py` → morning/meeting/evening |

### Object Model

- **Matters** — durable objects of executive attention
- **Threads** — source-linked activity chains (primary operational unit, matter_id nullable)
- **Artifacts** — immutable evidence (meetings, emails)
- **Commitments** — tracked obligations with ownership_type (ceo_owned/delegated/waiting_on)
- **Signals** — structured observations from interpretation
- **People** — canonical identities with roles (accountable/executor/stakeholder)

---

## Modification Guardrails

### Safe Without Confirmation
- Bug fixes within existing modules
- Adding new read-model queries to read.py
- Updating briefing/compat formatting
- Updating lifecycle timing constants

### Requires Confirmation
- Schema changes to atlas.db
- New modules or CLI entry points
- Changes to ingestion pipeline logic
- Changes to lifecycle automation rules
- Changes to graph match scoring or thresholds

### Breaking Changes
- atlas.db schema changes (affects command-centre reads)
- Changing CLI entry point signatures (affects briefing_consumer)
- Removing or renaming public functions (affects command-centre imports)
- Changing ingest_meeting/ingest_email contracts
