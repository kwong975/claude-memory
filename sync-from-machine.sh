#!/usr/bin/env bash
# sync-from-machine.sh — Refresh the bootstrap repo from the current machine
#
# Usage:
#   ./sync-from-machine.sh                # Sync global + workspace + repo-claudes
#   ./sync-from-machine.sh --with-memory  # Also sync memory-seed
#   ./sync-from-machine.sh --no-memory    # Explicitly skip memory (default)
#   ./sync-from-machine.sh --dry-run      # Print actions without copying
#
# Run from inside the claude-memory repo directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Defaults ---
DRY_RUN=false
WITH_MEMORY=false

# --- Parse args ---
for arg in "$@"; do
  case "$arg" in
    --dry-run)     DRY_RUN=true ;;
    --with-memory) WITH_MEMORY=true ;;
    --no-memory)   WITH_MEMORY=false ;;
    --help|-h)
      echo "Usage: ./sync-from-machine.sh [--dry-run] [--with-memory] [--no-memory]"
      echo ""
      echo "  --dry-run       Print what would be done without copying"
      echo "  --with-memory   Also sync memory-seed from ~/dev/claude-memory/"
      echo "  --no-memory     Skip memory-seed (default)"
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Run ./sync-from-machine.sh --help for usage"
      exit 1
      ;;
  esac
done

# --- Source paths ---
GLOBAL_SRC="$HOME/.claude"
WORKSPACE_SRC="$HOME/dev"
HOOKS_SRC="$HOME/dev/config/hooks"
REPO_BASE="$HOME/dev/kos-platform"
MEMORY_SRC="$HOME/dev/claude-memory"

# --- Helpers ---
SYNCED=0
MISSING=0
REMOVED=0

log_action()  { echo "  $1"; }
log_warn()    { echo "  WARN: $1"; }
log_missing() { echo "  MISSING: $1"; MISSING=$((MISSING + 1)); }

# Sync a single file from source to bootstrap repo.
# Usage: sync_file <source> <bootstrap_target>
sync_file() {
  local src="$1"
  local dst="$2"

  if [ ! -f "$src" ]; then
    log_missing "$src"
    return
  fi

  if $DRY_RUN; then
    log_action "[dry-run] $src -> $dst"
    SYNCED=$((SYNCED + 1))
    return
  fi

  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  log_action "$src -> $dst"
  SYNCED=$((SYNCED + 1))
}

# Sync a directory, removing stale files in the target that no longer exist in source.
# Usage: sync_dir <source_dir> <bootstrap_target_dir>
sync_dir() {
  local src="$1"
  local dst="$2"

  if [ ! -d "$src" ]; then
    log_missing "$src (directory)"
    return
  fi

  if $DRY_RUN; then
    log_action "[dry-run] sync $src/ -> $dst/"
    SYNCED=$((SYNCED + 1))
    return
  fi

  mkdir -p "$dst"

  # Copy all files from source
  find "$src" -type f | while read -r file; do
    local rel="${file#$src/}"
    local target="$dst/$rel"
    mkdir -p "$(dirname "$target")"
    cp "$file" "$target"
    log_action "$file -> $target"
    SYNCED=$((SYNCED + 1))
  done

  # Remove stale files in target that no longer exist in source
  if [ -d "$dst" ]; then
    find "$dst" -type f | while read -r file; do
      local rel="${file#$dst/}"
      if [ ! -f "$src/$rel" ]; then
        if $DRY_RUN; then
          log_action "[dry-run] would remove stale: $file"
        else
          rm "$file"
          log_action "Removed stale: $file"
          REMOVED=$((REMOVED + 1))
        fi
      fi
    done
  fi
}

# --- Header ---
echo "=== Claude Code Bootstrap Sync ==="
echo ""
if $DRY_RUN; then
  echo "MODE: dry-run (no files will be changed)"
fi
echo ""

# --- A. Global layer ---
echo "--- Global layer: $GLOBAL_SRC -> global/ ---"
sync_file "$GLOBAL_SRC/CLAUDE.md"        "$SCRIPT_DIR/global/CLAUDE.md"
sync_file "$GLOBAL_SRC/settings.json"     "$SCRIPT_DIR/global/settings.json"

for cmd in resume wrapup reflect audit design; do
  sync_file "$GLOBAL_SRC/commands/$cmd.md" "$SCRIPT_DIR/global/commands/$cmd.md"
done

for rule in package-managers database safety; do
  sync_file "$GLOBAL_SRC/rules/invariants/$rule.md" "$SCRIPT_DIR/global/rules/invariants/$rule.md"
done

sync_file "$GLOBAL_SRC/reference/skills-cheatsheet.md" "$SCRIPT_DIR/global/reference/skills-cheatsheet.md"
echo ""

# --- B. Workspace layer ---
echo "--- Workspace layer: $WORKSPACE_SRC -> workspace/ ---"
sync_file "$WORKSPACE_SRC/CLAUDE.md" "$SCRIPT_DIR/workspace/CLAUDE.md"

for rule in python typescript frontend api fleet migration; do
  sync_file "$WORKSPACE_SRC/.claude/rules/contextual/$rule.md" "$SCRIPT_DIR/workspace/.claude/rules/contextual/$rule.md"
done

echo ""
echo "--- Hooks: $HOOKS_SRC -> workspace/config/hooks/ ---"
for hook in LoadProjects ShowProjects SessionEndReminder AutoLint SafetyNet StopGate CompletionCheck AntiRationalization; do
  sync_file "$HOOKS_SRC/${hook}.hook.ts" "$SCRIPT_DIR/workspace/config/hooks/${hook}.hook.ts"
done
sync_file "$HOOKS_SRC/lib/log.ts"   "$SCRIPT_DIR/workspace/config/hooks/lib/log.ts"
sync_file "$HOOKS_SRC/lib/paths.ts" "$SCRIPT_DIR/workspace/config/hooks/lib/paths.ts"
echo ""

# --- D. Repo CLAUDE.md files ---
echo "--- Repo CLAUDE.md files: $REPO_BASE -> repo-claudes/ ---"
for repo in command-centre context-engine data-layer aureus skills claude-mcp-server agent-memory sni-knowledge; do
  sync_file "$REPO_BASE/$repo/CLAUDE.md" "$SCRIPT_DIR/repo-claudes/$repo/CLAUDE.md"
done

# Clean up repo-claudes for repos that no longer exist
for dir in "$SCRIPT_DIR"/repo-claudes/*/; do
  repo_name="$(basename "$dir")"
  if [ ! -d "$REPO_BASE/$repo_name" ]; then
    if $DRY_RUN; then
      log_action "[dry-run] would remove stale repo-claude: $dir"
    else
      rm -rf "$dir"
      log_action "Removed stale repo-claude: $dir"
      REMOVED=$((REMOVED + 1))
    fi
  fi
done
echo ""

# --- C. Memory seed (optional) ---
if $WITH_MEMORY; then
  echo "--- Memory seed: $MEMORY_SRC -> memory-seed/ ---"
  sync_file "$MEMORY_SRC/MEMORIES.md" "$SCRIPT_DIR/memory-seed/MEMORIES.md"
  sync_dir  "$MEMORY_SRC/projects"    "$SCRIPT_DIR/memory-seed/projects"
  sync_dir  "$MEMORY_SRC/known-issues" "$SCRIPT_DIR/memory-seed/known-issues"
  echo ""
else
  echo "--- Memory seed: SKIPPED (use --with-memory to include) ---"
  echo ""
fi

# --- Summary ---
echo "=== Sync complete ==="
echo "  Files synced:   $SYNCED"
echo "  Sources missing: $MISSING"
echo "  Stale removed:  $REMOVED"
if $DRY_RUN; then
  echo ""
  echo "  This was a dry run. No files were changed."
fi
