# data-layer (adata)

Captured knowledge store and data API gateway. Ingests meetings, email, books, finance.
Serves both captured and derived data via FastAPI.

---

## Key Facts

- Stack: Python 3.14+, FastAPI, uv, SQLite (WAL), sqlite-vec
- Package: `adata` (src layout, CLI via click)
- Owns: knowledge.db, search.db, finance.db (all at ~/kos-platform/data/db/)
- Reads: atlas.db (context-engine-owned, for thread intelligence injection)
- Consumed by: aureus (finance UI), claude-mcp-server (MCP proxy), context-engine (knowledge queries)
- API: `:8083` (FastAPI) + `:18790` search service (standalone FastAPI)

### Source Layout

| Directory | Purpose |
|-----------|---------|
| `src/api/` | FastAPI routers — finance, networth, knowledge, insurance, RE, ESOP, loans, SEP |
| `src/daemons/` | Background services — search_service, watcher, reindex, todoist sync, goodreads |
| `src/ingestion/` | Meeting/book/email ingestion pipeline (LLM extraction, parsing, schema validation) |
| `src/` (top-level) | Core modules — knowledge_service, finance_networth, networth_engine, finalization, session_ingest |
| `db/` | Schema files — base + 10 migrations |

### CLI

`adata` command: backup, books, finance, knowledge, pipeline, ops, costs, taxonomy

### Runtime (launchd on Mini)

| Job | Purpose |
|-----|---------|
| `ai.adata.pipeline` | Boot launcher — starts watcher, reindex, search-sync daemons |
| `ai.adata.search-service` | Standalone vector+FTS5 search API (:18790) |

---

## Modification Guardrails

### Safe Without Confirmation
- Bug fixes within existing routers or services
- Adding new query endpoints to existing routers
- Updating ingestion parsing logic (non-schema)
- CLI subcommand additions

### Requires Confirmation
- Schema changes to knowledge.db, finance.db, or search.db (migration file required)
- New routers or API entry points
- Changes to ingestion pipeline stage order or LLM prompts
- Changes to finalization workflow (affects downstream: Todoist sync, thread scan)
- Changes to networth_engine calculation logic

### Breaking Changes
- API contract changes (aureus, claude-mcp-server, context-engine all consume)
- Schema migrations (need deployment strategy for Mini)
- Credential handling changes (credentials.py pattern)
- Search service protocol changes (context-engine consumes)
