# claude-mcp-server

MCP server bridging Claude Desktop to the KOS knowledge base.
Proxy layer — no database ownership, all data via data-layer API.

---

## Key Facts

- Stack: Python 3.14+, FastMCP, httpx
- Single source file: `server.py` (~935 lines)
- Connects to: data-layer API (HTTP, default `100.77.165.99:8083`)
- Runtime: `python server.py` on MacBook, consumed by Claude Desktop via stdio
- 13 MCP tools registered

### Tools

| Group | Tools |
|-------|-------|
| Knowledge | `knowledge_search`, `knowledge_show`, `knowledge_prep` |
| SEP | `sep_search`, `sep_session`, `sep_transcript`, `sep_instructor`, `sep_concepts`, `sep_cases`, `sep_framework_create/list/get`, `sep_semantic_search` |

---

## Modification Guardrails

### Safe Without Confirmation
- Updating tool descriptions or parameter docs
- Bug fixes in response formatting
- Adding new read-only tools that wrap existing adata endpoints

### Requires Confirmation
- Adding tools that write data (any mutation via adata API)
- Changing tool names (breaks Claude Desktop tool references)
- Changing adata API connection logic

### Breaking Changes
- Tool schema changes (Claude Desktop caches tool definitions)
- Removing or renaming existing tools
- Changing stdio transport protocol
