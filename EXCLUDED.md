# Excluded Items

Items intentionally excluded from the bootstrap repo and why.

## Application source code

| Excluded | Reason |
|---|---|
| All repo source code (Python, TypeScript, etc.) | This is a config bootstrap, not a code backup. Repos are cloned from GitHub. |
| `~/dev/kos-platform/*/` (everything except CLAUDE.md) | Only the guardrail file is needed for bootstrapping Claude Code behavior. |

## Secrets and credentials

| Excluded | Reason |
|---|---|
| `.env` files | Contain environment-specific secrets. |
| `credentials.json` | API keys and tokens. |
| `~/.claude/auth*` | Claude Code authentication tokens. |
| `~/.claude/policy-limits.json` | Account-specific policy data. |
| `~/.claude/mcp-needs-auth-cache.json` | Session-specific auth cache. |
| `~/.claude/security_warnings_state_*.json` | Per-session security state. |
| Any file containing API keys or tokens | Security policy: secrets never in repos. |

## Caches and generated artifacts

| Excluded | Reason |
|---|---|
| `node_modules/` | Package manager output. Reinstall from lockfile. |
| `.venv/` | Python virtual environments. Recreate with `uv sync`. |
| `__pycache__/` | Python bytecode cache. |
| `.ruff_cache/` | Linter cache. |
| `dist/`, `build/`, `.next/` | Build output. Rebuild from source. |
| `*.pyc` | Compiled Python files. |
| `.DS_Store` | macOS Finder metadata. |

## Claude Code internal state

| Excluded | Reason |
|---|---|
| `~/.claude/sessions/` | Per-session conversation data. Machine-specific. |
| `~/.claude/history.jsonl` | Command history. Machine-specific. |
| `~/.claude/cache/` | Internal cache. |
| `~/.claude/debug/` | Debug logs. |
| `~/.claude/ide/` | IDE integration state. |
| `~/.claude/telemetry/` | Usage telemetry. |
| `~/.claude/statsig/` | Feature flag state. |
| `~/.claude/todos/` | Per-session todo state. |
| `~/.claude/projects/` | Claude Code's internal project state (not our project files). |
| `~/.claude/plans/` | Claude Code's internal plans. |
| `~/.claude/paste-cache/` | Clipboard cache. |
| `~/.claude/session-env/` | Session environment snapshots. |
| `~/.claude/shell-snapshots/` | Shell state snapshots. |
| `~/.claude/file-history/` | File edit history. |
| `~/.claude/backups/` | Settings backups. |
| `~/.claude/hook-calibration.jsonl` | Hook performance data. |
| `~/.claude/settings.json.backup` | Settings backup files. |
| `~/.claude/settings.json.bak` | Settings backup files. |
| `~/.claude/settings.json.orig` | Settings backup files. |
| `~/.claude/stats-cache.json` | Statistics cache. |
| `~/.claude/agents/` | Agent configuration (managed separately). |
| `~/.claude/plugins/` | Plugin state. |
| `~/.claude/tasks/` | Task state. |

## Machine-specific artifacts

| Excluded | Reason |
|---|---|
| Temp files (`*.tmp`, `*.swp`, `*.swo`) | Editor swap files. |
| Log files (`*.log`) | Machine-specific runtime logs. |
| Lock files (`*.lock`, `uv.lock`, `bun.lockb`) | Dependency locks are per-repo, not per-bootstrap. |
| Database files (`*.db`, `*.sqlite`) | Data files belong in `~/kos-platform/data/db/`. |
