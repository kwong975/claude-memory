# claude-memory

A portable bootstrap installer for a Claude Code operating system.

This repo packages the full Claude Code configuration stack — global settings, workspace rules, hooks, repo guardrails, and optionally personal memory — into something you can install on a new machine in one command.

## What it installs

| Layer | What | Where it goes |
|-------|------|---------------|
| **Global** | CLAUDE.md, settings.json, slash commands, invariant rules, reference docs | `~/.claude/` |
| **Workspace** | Workspace CLAUDE.md, contextual rules (Python, TS, frontend, etc.) | `~/dev/` and `~/dev/.claude/` |
| **Hooks** | 8 Claude Code hooks + shared lib | `~/dev/config/hooks/` |
| **Repo guardrails** | Per-repo CLAUDE.md files (no source code) | `~/dev/kos-platform/<repo>/CLAUDE.md` |
| **Memory seed** (optional) | MEMORIES.md, project files, known-issues | `~/dev/claude-memory/` |

## What it does NOT include

- Application source code (repos are not packaged — only their CLAUDE.md files)
- Secrets, API keys, credentials, `.env` files
- Caches, `node_modules`, `.venv`, build artifacts
- Machine-specific temp files, session data, telemetry
- Git history or auth tokens
- Claude Code internal state (sessions, history, debug logs)

See [EXCLUDED.md](EXCLUDED.md) for the full exclusion list with rationale.

## Repo structure

```
claude-memory/
├── install.sh                  # Install bootstrap onto a machine
├── sync-from-machine.sh        # Refresh bootstrap from current machine
├── verify.sh                   # Verify repo structure integrity
├── bootstrap.config.example    # Documents source/target path mapping
├── manifest.md                 # What's included, source/target, required/optional
├── EXCLUDED.md                 # What's excluded and why
│
├── global/                     # ~/.claude/ contents
│   ├── CLAUDE.md
│   ├── settings.json
│   ├── commands/               # Slash commands
│   ├── rules/invariants/       # Global rules
│   └── reference/              # Reference docs
│
├── workspace/                  # ~/dev/ contents
│   ├── CLAUDE.md
│   ├── .claude/rules/contextual/   # Language/context rules
│   └── config/hooks/           # Claude Code hooks
│
├── repo-claudes/               # Per-repo CLAUDE.md guardrails
│   ├── command-centre/
│   ├── context-engine/
│   ├── data-layer/
│   ├── aureus/
│   ├── skills/
│   ├── claude-mcp-server/
│   ├── agent-memory/
│   └── sni-knowledge/
│
├── memory-seed/                # Personal data (gitignored)
│   ├── MEMORIES.md
│   ├── projects/
│   └── known-issues/
│
├── templates/                  # Blank templates for new memory files
└── examples/                   # Populated examples showing usage
```

## Syncing from the current machine

To refresh the bootstrap repo with the latest files from your current machine:

```bash
cd ~/dev/claude-memory
./sync-from-machine.sh              # Sync config only
./sync-from-machine.sh --with-memory # Also snapshot memory files
./sync-from-machine.sh --dry-run     # Preview without changes
```

This overwrites files in the bootstrap repo with the live versions. Run this before committing updates.

## Installing on a new machine

```bash
# Clone the repo
git clone https://github.com/kos-platform/claude-memory.git ~/dev/claude-memory
cd ~/dev/claude-memory

# Preview what will be installed
./install.sh --user-name "YourName" --dry-run

# Install (safe — skips existing files)
./install.sh --user-name "YourName"

# Install and overwrite existing files
./install.sh --user-name "YourName" --force

# Also install memory seed
./install.sh --user-name "YourName" --with-memory
```

## Optional memory-seed mode

The `memory-seed/` directory holds personal operational memory:
- `MEMORIES.md` — preferences, corrections, calibrations
- `projects/` — active project tracking files
- `known-issues/` — per-repo gotchas

This data is **gitignored by default** because it contains personal/project-specific data. To include it:

1. Sync it: `./sync-from-machine.sh --with-memory`
2. Install it: `./install.sh --with-memory`

If you want to commit memory-seed to the repo (e.g., for a private repo), remove the `memory-seed/` line from `.gitignore`.

## Safety and overwrite behavior

- **--user-name**: required. Your name, used in prompts and hooks that address you personally.
- **Default mode**: never overwrites existing files. Prints a warning and skips.
- **--force**: overwrites existing files without prompting.
- **--dry-run**: prints every action without touching the filesystem.
- **Never deletes** anything on the target machine.
- **Never copies secrets** — credentials, tokens, and env files are excluded at the source.
- **Placeholder replacement**: `__HOME__` and `__USER_NAME__` in bootstrap files are replaced with your actual home directory and name during install.
- If a target repo directory doesn't exist, the installer warns and skips that repo's CLAUDE.md rather than failing.

## Post-install checks

After installing, verify your setup:

```bash
# Verify the bootstrap repo itself
./verify.sh

# Check Claude Code picks up the config
claude --version  # Confirm Claude Code is installed
ls ~/.claude/CLAUDE.md  # Global config present
ls ~/dev/CLAUDE.md  # Workspace config present
ls ~/dev/config/hooks/*.hook.ts  # Hooks present
```

Then start a Claude Code session and confirm:
- Slash commands work (`/resume`, `/wrapup`, etc.)
- Hooks fire on session start (you should see project loading)
- Safety rules are active (try a destructive command to verify SafetyNet)

## Known limitations

- **Path assumptions**: Scripts assume `~/dev/` as the workspace root and `~/dev/kos-platform/` as the repo base. Edit the scripts if your layout differs.
- **No config file support**: The `bootstrap.config.example` is documentation only. Scripts use hardcoded paths. A future version could read a config file.
- **No selective install**: You can't install just hooks or just rules. It's all-or-nothing per layer (global, workspace, repo-claudes, memory).
- **macOS-oriented**: Scripts use `find` and `cp` syntax that works on macOS and Linux. Not tested on Windows/WSL.
- **Hooks require bun**: All hooks are TypeScript executed by [bun](https://bun.sh/). Install bun on the target machine.

## Templates and examples

The `templates/` directory contains blank templates for creating new memory files:
- `MEMORIES.md` — blank memories template
- `projects/_template.md` — blank project file
- `known-issues/_template.md` — blank known-issues file

The `examples/` directory contains populated examples showing what filled-in files look like.

## License

[MIT](LICENSE)
