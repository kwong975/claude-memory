# claude-memory

A persistent memory and project management system for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

Claude Code is stateless by default — every session starts fresh. **claude-memory** gives it a structured, file-based memory that persists across sessions, so Claude remembers your preferences, tracks your projects, and learns from corrections without you repeating yourself.

## Why this exists

After months of daily Claude Code use, a pattern emerged: every session started with re-explaining the same preferences, re-establishing the same architectural decisions, and re-orienting Claude to the same active projects. The built-in auto-memory helps, but it's unstructured and per-project.

claude-memory is a structured alternative — explicit files with clear schemas that you control. Claude reads them at session start and updates them (with your approval) at session end. You own the data, you review every write, and you can version-control the whole thing.

## What it does

- **Remembers you** — your role, preferences, how you like to work, corrections you've made
- **Tracks decisions** — architectural and tooling decisions that apply across projects
- **Manages projects** — active projects with next steps, logs, and notes files
- **Tracks known issues** — per-repo gotchas that persist across sessions
- **Learns from corrections** — when you correct Claude, it proposes a memory update so it doesn't repeat the mistake

## What it is not

- Not an AI agent or autonomous system — Claude proposes updates, you approve them
- Not a replacement for documentation — this is operational memory, not docs
- Not tied to any specific tech stack — it's markdown files with conventions

## Quick start

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/claude-memory.git ~/dev/claude-memory

# Run setup to create your personal memory files from templates
cd ~/dev/claude-memory
./setup.sh

# Tell Claude Code where to find your memory
# Add to ~/.claude/settings.json:
{
  "env": {
    "MEMORY_DIR": "/path/to/claude-memory"
  }
}
```

Then edit `MEMORIES.md` to fill in your details, and you're running.

## How it works

```
Session start
  └─ Claude reads MEMORIES.md (who you are, preferences, corrections)
  └─ Claude reads active project files (what you're working on)
  └─ Claude reads known-issues (gotchas to watch for)

During session
  └─ Claude works with full context of your preferences and projects
  └─ When you correct Claude, it notes the correction for later

Session end (/wrapup)
  └─ Claude proposes updates: project log entries, new corrections, next steps
  └─ You approve or reject each proposed write
  └─ Approved updates are written to memory files
```

## File structure

```
claude-memory/
├── MEMORIES.md              # Your preferences, corrections, calibrations
├── decisions.md             # Cross-project architectural decisions
├── projects/
│   ├── my-project.md        # Active project: next steps + log
│   ├── my-project-notes.md  # Detailed findings and reasoning
│   └── archive/             # Completed projects
├── known-issues/
│   └── repo-name.md         # Per-repo gotchas and workarounds
├── templates/               # Starting templates for new files
│   ├── MEMORIES.md
│   ├── decisions.md
│   ├── projects/_template.md
│   └── known-issues/_template.md
└── examples/                # Populated examples showing real usage
    ├── MEMORIES-example.md
    └── project-example.md
```

### File details

| File | Purpose | Updated by |
|------|---------|------------|
| `MEMORIES.md` | Who you are, how you work, corrections | `/wrapup` (with approval) |
| `decisions.md` | Technical decisions that apply across projects | Manual or `/wrapup` |
| `projects/<name>.md` | Active project tracking (frontmatter + Next + Log) | `/wrapup` (with approval) |
| `projects/<name>-notes.md` | Detailed reasoning and findings | `/wrapup` or manual |
| `known-issues/<repo>.md` | Per-repo gotchas and workarounds | Manual |

### Project file format

Project files use YAML frontmatter for metadata:

```yaml
---
workspace: dev          # Which workspace this belongs to
status: active          # active | paused | complete | reference
updated: 2026-04-06     # Last updated date
---
```

Followed by markdown sections: `# Title`, `## Purpose`, `## Next` (checklist), `## Log` (dated entries).

**Lifecycle:** `active` (Claude suggests work) → `paused` (Claude doesn't suggest) → `complete` (move to `archive/`).

### MEMORIES.md sections

| Section | What goes here |
|---------|---------------|
| About You | Name, role, context — helps Claude calibrate tone and depth |
| Working Principles | How you want Claude to approach work |
| Explicit Calibrations | Specific rules for specific situations |
| Stated Preferences | How you prefer things done (tools, style, workflow) |
| Behavioral Corrections | Mistakes Claude made that it should not repeat |

## Integration with Claude Code

claude-memory is designed to work with Claude Code's existing extension points:

### Slash commands (optional)

If you use [Claude Code slash commands](https://docs.anthropic.com/en/docs/claude-code/slash-commands), these complement the memory system:

- `/resume` — reads memory + git state to produce a re-entry briefing
- `/wrapup` — proposes memory updates at session end (approval required)
- `/reflect` — audits memory for stale, duplicate, or contradictory entries
- `/audit` — checks system health (file coverage, budgets, hooks)
- `/design` — structured design thinking before implementation

### Hooks (optional)

[Claude Code hooks](https://docs.anthropic.com/en/docs/claude-code/hooks) can automate memory loading:

- **SessionStart** — load active projects and corrections into context
- **Stop** — remind Claude to check for memory updates
- **UserPromptSubmit** — detect session-end signals and prompt for wrapup

See the [companion hooks repo](https://github.com/YOUR_USERNAME/claude-code-hooks) for ready-to-use hook scripts. *(Coming soon)*

### Settings

Add to `~/.claude/settings.json`:

```json
{
  "env": {
    "MEMORY_DIR": "/absolute/path/to/claude-memory"
  }
}
```

### CLAUDE.md integration

Reference the memory system in your project or global `CLAUDE.md`:

```markdown
## Persistent Memory

- Preferences, corrections, calibrations → `claude-memory/MEMORIES.md`
- Technical decisions → `claude-memory/decisions.md`
- Always propose exact text and wait for approval before writing to memory files.

## Project Tracking

Project files: `~/dev/claude-memory/projects/`
- `<project>.md` — frontmatter (workspace, status) + purpose, next steps, log
- `<project>-notes.md` — detailed findings, reasoning

When work completes: update Log (one-liner), Next (remaining steps), Notes (detail).
Lifecycle: active → suggest work | paused → don't suggest | complete → archive.
```

## Customization

The system is deliberately simple — markdown files with conventions, not a framework with dependencies.

**Add new sections to MEMORIES.md** — the section names are just headers. Add whatever categories make sense for your work.

**Change the project file format** — the frontmatter fields (`workspace`, `status`, `updated`) are used by the hooks. Everything else is convention you can adapt.

**Add new known-issues repos** — create `known-issues/<repo-name>.md` for any repo you work with frequently.

**Adjust budgets** — if you use the `/audit` command, it checks line counts. Default budgets: MEMORIES.md (200 lines), individual files (30 lines), per-repo CLAUDE.md (100 lines). These are guidelines, not hard limits.

## Design principles

1. **Human-in-the-loop** — Claude proposes, you approve. No silent writes to memory.
2. **Plain text** — everything is markdown. No databases, no binary formats, no dependencies.
3. **You own the data** — memory files live on your machine, in your repo. Nothing is sent anywhere.
4. **Minimal structure** — just enough schema to be useful. Not so much that it becomes overhead.
5. **Composable** — use the parts that help. Skip the parts that don't. Each piece works independently.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

[MIT](LICENSE) — use it however you want.
