# Manifest

Everything included in the bootstrap repo, where it comes from, and where it goes.

## Global layer

| Bootstrap path | Source on machine | Install target | Required |
|---|---|---|---|
| `global/CLAUDE.md` | `~/.claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Yes |
| `global/settings.json` | `~/.claude/settings.json` | `~/.claude/settings.json` | Yes |
| `global/commands/resume.md` | `~/.claude/commands/resume.md` | `~/.claude/commands/resume.md` | Yes |
| `global/commands/wrapup.md` | `~/.claude/commands/wrapup.md` | `~/.claude/commands/wrapup.md` | Yes |
| `global/commands/reflect.md` | `~/.claude/commands/reflect.md` | `~/.claude/commands/reflect.md` | Yes |
| `global/commands/audit.md` | `~/.claude/commands/audit.md` | `~/.claude/commands/audit.md` | Yes |
| `global/commands/design.md` | `~/.claude/commands/design.md` | `~/.claude/commands/design.md` | Yes |
| `global/rules/invariants/package-managers.md` | `~/.claude/rules/invariants/package-managers.md` | `~/.claude/rules/invariants/package-managers.md` | Yes |
| `global/rules/invariants/database.md` | `~/.claude/rules/invariants/database.md` | `~/.claude/rules/invariants/database.md` | Yes |
| `global/rules/invariants/safety.md` | `~/.claude/rules/invariants/safety.md` | `~/.claude/rules/invariants/safety.md` | Yes |
| `global/reference/skills-cheatsheet.md` | `~/.claude/reference/skills-cheatsheet.md` | `~/.claude/reference/skills-cheatsheet.md` | Optional |

## Workspace layer

| Bootstrap path | Source on machine | Install target | Required |
|---|---|---|---|
| `workspace/CLAUDE.md` | `~/dev/CLAUDE.md` | `~/dev/CLAUDE.md` | Yes |
| `workspace/.claude/rules/contextual/python.md` | `~/dev/.claude/rules/contextual/python.md` | `~/dev/.claude/rules/contextual/python.md` | Yes |
| `workspace/.claude/rules/contextual/typescript.md` | `~/dev/.claude/rules/contextual/typescript.md` | `~/dev/.claude/rules/contextual/typescript.md` | Yes |
| `workspace/.claude/rules/contextual/frontend.md` | `~/dev/.claude/rules/contextual/frontend.md` | `~/dev/.claude/rules/contextual/frontend.md` | Yes |
| `workspace/.claude/rules/contextual/api.md` | `~/dev/.claude/rules/contextual/api.md` | `~/dev/.claude/rules/contextual/api.md` | Yes |
| `workspace/.claude/rules/contextual/fleet.md` | `~/dev/.claude/rules/contextual/fleet.md` | `~/dev/.claude/rules/contextual/fleet.md` | Yes |
| `workspace/.claude/rules/contextual/migration.md` | `~/dev/.claude/rules/contextual/migration.md` | `~/dev/.claude/rules/contextual/migration.md` | Yes |

## Hooks

| Bootstrap path | Source on machine | Install target | Required |
|---|---|---|---|
| `workspace/config/hooks/LoadProjects.hook.ts` | `~/dev/config/hooks/LoadProjects.hook.ts` | `~/dev/config/hooks/LoadProjects.hook.ts` | Yes |
| `workspace/config/hooks/ShowProjects.hook.ts` | `~/dev/config/hooks/ShowProjects.hook.ts` | `~/dev/config/hooks/ShowProjects.hook.ts` | Yes |
| `workspace/config/hooks/SessionEndReminder.hook.ts` | `~/dev/config/hooks/SessionEndReminder.hook.ts` | `~/dev/config/hooks/SessionEndReminder.hook.ts` | Yes |
| `workspace/config/hooks/AutoLint.hook.ts` | `~/dev/config/hooks/AutoLint.hook.ts` | `~/dev/config/hooks/AutoLint.hook.ts` | Yes |
| `workspace/config/hooks/SafetyNet.hook.ts` | `~/dev/config/hooks/SafetyNet.hook.ts` | `~/dev/config/hooks/SafetyNet.hook.ts` | Yes |
| `workspace/config/hooks/StopGate.hook.ts` | `~/dev/config/hooks/StopGate.hook.ts` | `~/dev/config/hooks/StopGate.hook.ts` | Yes |
| `workspace/config/hooks/CompletionCheck.hook.ts` | `~/dev/config/hooks/CompletionCheck.hook.ts` | `~/dev/config/hooks/CompletionCheck.hook.ts` | Yes |
| `workspace/config/hooks/AntiRationalization.hook.ts` | `~/dev/config/hooks/AntiRationalization.hook.ts` | `~/dev/config/hooks/AntiRationalization.hook.ts` | Yes |
| `workspace/config/hooks/lib/log.ts` | `~/dev/config/hooks/lib/log.ts` | `~/dev/config/hooks/lib/log.ts` | Yes |
| `workspace/config/hooks/lib/paths.ts` | `~/dev/config/hooks/lib/paths.ts` | `~/dev/config/hooks/lib/paths.ts` | Yes |

## Repo CLAUDE.md guardrails

| Bootstrap path | Source on machine | Install target | Required |
|---|---|---|---|
| `repo-claudes/command-centre/CLAUDE.md` | `~/dev/kos-platform/command-centre/CLAUDE.md` | `~/dev/kos-platform/command-centre/CLAUDE.md` | Yes |
| `repo-claudes/context-engine/CLAUDE.md` | `~/dev/kos-platform/context-engine/CLAUDE.md` | `~/dev/kos-platform/context-engine/CLAUDE.md` | Yes |
| `repo-claudes/data-layer/CLAUDE.md` | `~/dev/kos-platform/data-layer/CLAUDE.md` | `~/dev/kos-platform/data-layer/CLAUDE.md` | Yes |
| `repo-claudes/aureus/CLAUDE.md` | `~/dev/kos-platform/aureus/CLAUDE.md` | `~/dev/kos-platform/aureus/CLAUDE.md` | Yes |
| `repo-claudes/skills/CLAUDE.md` | `~/dev/kos-platform/skills/CLAUDE.md` | `~/dev/kos-platform/skills/CLAUDE.md` | Yes |
| `repo-claudes/claude-mcp-server/CLAUDE.md` | `~/dev/kos-platform/claude-mcp-server/CLAUDE.md` | `~/dev/kos-platform/claude-mcp-server/CLAUDE.md` | Yes |
| `repo-claudes/agent-memory/CLAUDE.md` | `~/dev/kos-platform/agent-memory/CLAUDE.md` | `~/dev/kos-platform/agent-memory/CLAUDE.md` | Yes |
| `repo-claudes/sni-knowledge/CLAUDE.md` | `~/dev/kos-platform/sni-knowledge/CLAUDE.md` | `~/dev/kos-platform/sni-knowledge/CLAUDE.md` | Yes |

## Memory seed (optional, gitignored)

| Bootstrap path | Source on machine | Install target | Required |
|---|---|---|---|
| `memory-seed/MEMORIES.md` | `~/dev/claude-memory/MEMORIES.md` | `~/dev/claude-memory/MEMORIES.md` | Optional |
| `memory-seed/projects/` | `~/dev/claude-memory/projects/` | `~/dev/claude-memory/projects/` | Optional |
| `memory-seed/projects/archive/` | `~/dev/claude-memory/projects/archive/` | `~/dev/claude-memory/projects/archive/` | Optional |
| `memory-seed/known-issues/` | `~/dev/claude-memory/known-issues/` | `~/dev/claude-memory/known-issues/` | Optional |

## Templates and examples

| Bootstrap path | Purpose | Required |
|---|---|---|
| `templates/MEMORIES.md` | Blank MEMORIES.md template | Optional |
| `templates/projects/_template.md` | Blank project file template | Optional |
| `templates/known-issues/_template.md` | Blank known-issues template | Optional |
| `examples/MEMORIES-example.md` | Populated MEMORIES.md example | Optional |
| `examples/project-example.md` | Populated project file example | Optional |
