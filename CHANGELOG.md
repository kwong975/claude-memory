# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/), and this project adheres to [Semantic Versioning](https://semver.org/).

## [2.0.0] - 2026-04-06

### Changed

- **Full restructure as a bootstrap installer.** Repo is now a portable system pack for reproducing a Claude Code operating environment on any machine.
- Repo organized into four layers: `global/` (~/.claude), `workspace/` (~/dev), `repo-claudes/` (per-repo CLAUDE.md guardrails), `memory-seed/` (optional personal data).
- `install.sh` replaces `setup.sh` — installs all layers with `--dry-run`, `--force`, `--with-memory` support.
- `sync-from-machine.sh` refreshes bootstrap from the current machine's live config.
- `verify.sh` checks repo structure integrity (48 checks).
- Hooks moved from top-level `hooks/` to `workspace/config/hooks/`.

### Added

- `install.sh` — safe installer with overwrite protection and dry-run
- `sync-from-machine.sh` — refresh bootstrap from live machine
- `verify.sh` — structure integrity verification
- `manifest.md` — complete file manifest with source/target mapping
- `EXCLUDED.md` — documents what is intentionally not packaged
- `bootstrap.config.example` — documents path mapping (documentation only)
- `global/` layer — CLAUDE.md, settings.json, slash commands, invariant rules, reference docs
- `workspace/` layer — workspace CLAUDE.md, contextual rules, all hooks
- `repo-claudes/` layer — per-repo CLAUDE.md files (no source code)
- `AntiRationalization.hook.ts` — documentation for the prompt-type Stop hook
- `CompletionCheck.hook.ts` — deterministic false-completion detector

### Removed

- `setup.sh` — replaced by `install.sh`
- `decisions.md` — retired from Claude Code; lives on Mini for agent-memory only
- Top-level `hooks/` directory — moved to `workspace/config/hooks/`

## [1.0.0] - 2026-04-06

### Added

- Initial release
- MEMORIES.md template for preferences, corrections, and calibrations
- Project file format with YAML frontmatter (workspace, status, updated)
- Known-issues tracking per repository
- Setup script for bootstrapping personal memory files
- Example files showing populated memory and project tracking
- Integration guide for Claude Code (settings, CLAUDE.md, hooks, slash commands)
