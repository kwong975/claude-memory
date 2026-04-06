# Dev Workspace

`~/dev/` is the primary development workspace on the MacBook.
Mac Mini is the deployment target. GitHub org: `kos-platform`.

## Structure

```
~/dev/
  kos-platform/           KOS Platform — all platform repos + shared data
    data-layer/            Captured knowledge store (Python, uv)
    context-engine/        Intelligence engine (Python, uv)
    command-centre/        Operator interface (React + Python)
    skills/                Agent identities + skill marketplace
    aureus/                Finance frontend (React, bun)
    claude-mcp-server/     Claude Desktop bridge (Python, uv)
    data/                  Shared data — DBs, vault
  claude-memory/           Claude Code memory — preferences, projects, decisions
  config/
    hooks/                 Claude Code session hooks
  sandbox/                 Reference code and experiments
  loose_scripts/           One-off utility scripts
```

## Git

- Conventional commits: `feat:`, `fix:`, `chore:`, `refactor:`, `test:`, `docs:`
- Branch naming: `feat/<slug>`, `fix/<slug>`, `chore/<slug>`
- Never commit unless explicitly asked
- Never force push main/master

## General

- Read before writing — never modify code you haven't read
- New files go in the existing directory that matches their concern
- No new directories without asking
- Check sibling files before naming anything
- Never create .md documentation files unless explicitly requested

## Persistent Memory

- Behavioural corrections, preferences, calibrations → `claude-memory/MEMORIES.md`
- Always propose exact text inline and wait for approval before writing.

## Project Tracking

Project files: `~/dev/claude-memory/projects/`
- `<project>.md` — frontmatter (workspace, status) + purpose, next steps, log
- `<project>-notes.md` — detailed findings, reasoning

When work completes: update Log (one-liner), Next (remaining steps), Notes (detail).
Lifecycle: active → suggest work | paused → don't suggest | complete → archive.

## References

- Known issues: `claude-memory/known-issues/`
- Language/tooling standards: `~/.claude/rules/` and `~/dev/.claude/rules/`
