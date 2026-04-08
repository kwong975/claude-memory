#!/usr/bin/env bash
# install.sh — Install the Claude Code bootstrap onto a machine
#
# Usage:
#   ./install.sh --user-name "Kelly"    # Install with user name for personalization
#   ./install.sh --dry-run              # Print actions without copying
#   ./install.sh --force                # Overwrite existing files without prompting
#   ./install.sh --with-memory          # Also install memory-seed
#
# Safe by default: never deletes, never overwrites without confirmation.
# Replaces __HOME__ and __USER_NAME__ placeholders in installed files.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Defaults ---
DRY_RUN=false
FORCE=false
WITH_MEMORY=false
USER_NAME=""

# --- Parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)     DRY_RUN=true; shift ;;
    --force)       FORCE=true; shift ;;
    --with-memory) WITH_MEMORY=true; shift ;;
    --user-name)   USER_NAME="$2"; shift 2 ;;
    --help|-h)
      echo "Usage: ./install.sh --user-name <name> [--dry-run] [--force] [--with-memory]"
      echo ""
      echo "  --user-name <n> Your name (used in prompts/hooks that address you)"
      echo "  --dry-run       Print what would be done without copying"
      echo "  --force         Overwrite existing files without prompting"
      echo "  --with-memory   Also install memory-seed (MEMORIES.md, projects/, known-issues/)"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Run ./install.sh --help for usage"
      exit 1
      ;;
  esac
done

# --- Prompt for user name if not provided ---
if [ -z "$USER_NAME" ]; then
  printf "Your name (for personalization in prompts/hooks): "
  read -r USER_NAME
  if [ -z "$USER_NAME" ]; then
    echo "Error: user name is required. Use --user-name <name> or enter it when prompted."
    exit 1
  fi
fi

# --- Target paths (overridable via env vars) ---
GLOBAL_TARGET="${CLAUDE_GLOBAL_DIR:-$HOME/.claude}"
WORKSPACE_TARGET="${CLAUDE_WORKSPACE_DIR:-$HOME/dev}"
REPO_BASE="${CLAUDE_REPO_BASE:-$HOME/dev/kos-platform}"
MEMORY_TARGET="${CLAUDE_MEMORY_DIR:-$HOME/dev/claude-memory}"

# --- Helpers ---
COPIED=0
SKIPPED=0
WARNED=0

log_action() { echo "  $1"; }
log_warn()   { echo "  WARN: $1"; WARNED=$((WARNED + 1)); }

# Copy a single file. Creates parent directories as needed.
# Usage: copy_file <source> <target>
copy_file() {
  local src="$1"
  local dst="$2"

  if [ ! -f "$src" ]; then
    log_warn "Source missing: $src"
    return
  fi

  if $DRY_RUN; then
    log_action "[dry-run] $src -> $dst"
    COPIED=$((COPIED + 1))
    return
  fi

  local dst_dir
  dst_dir="$(dirname "$dst")"
  mkdir -p "$dst_dir"

  if [ -f "$dst" ] && ! $FORCE; then
    log_warn "Exists, skipping (use --force to overwrite): $dst"
    SKIPPED=$((SKIPPED + 1))
    return
  fi

  # Copy and replace placeholders
  sed -e "s|__HOME__|$HOME|g" -e "s|__USER_NAME__|$USER_NAME|g" "$src" > "$dst"
  log_action "$src -> $dst"
  COPIED=$((COPIED + 1))
}

# Copy a directory recursively. Creates target as needed.
# Usage: copy_dir <source_dir> <target_dir>
copy_dir() {
  local src="$1"
  local dst="$2"

  if [ ! -d "$src" ]; then
    log_warn "Source directory missing: $src"
    return
  fi

  if $DRY_RUN; then
    log_action "[dry-run] $src/ -> $dst/"
    COPIED=$((COPIED + 1))
    return
  fi

  mkdir -p "$dst"

  # Copy files preserving structure, respecting --force
  while IFS= read -r file; do
    local rel="${file#$src/}"
    local target="$dst/$rel"

    if [ -f "$target" ] && ! $FORCE; then
      log_warn "Exists, skipping: $target"
      SKIPPED=$((SKIPPED + 1))
    else
      mkdir -p "$(dirname "$target")"
      sed -e "s|__HOME__|$HOME|g" -e "s|__USER_NAME__|$USER_NAME|g" "$file" > "$target"
      log_action "$file -> $target"
      COPIED=$((COPIED + 1))
    fi
  done < <(find "$src" -type f)
}

# --- Header ---
echo "=== Claude Code Bootstrap Installer ==="
echo ""
echo "User:  $USER_NAME"
echo "Home:  $HOME"
echo ""
if $DRY_RUN; then
  echo "MODE: dry-run (no files will be copied)"
elif $FORCE; then
  echo "MODE: force (existing files will be overwritten)"
else
  echo "MODE: safe (existing files will be skipped)"
fi
echo ""

# --- A. Global layer -> ~/.claude/ ---
echo "--- Global layer -> $GLOBAL_TARGET/ ---"
copy_file "$SCRIPT_DIR/global/CLAUDE.md"        "$GLOBAL_TARGET/CLAUDE.md"
copy_file "$SCRIPT_DIR/global/settings.json"     "$GLOBAL_TARGET/settings.json"

for cmd in resume wrapup reflect audit design; do
  copy_file "$SCRIPT_DIR/global/commands/$cmd.md" "$GLOBAL_TARGET/commands/$cmd.md"
done

for rule in package-managers database safety; do
  copy_file "$SCRIPT_DIR/global/rules/invariants/$rule.md" "$GLOBAL_TARGET/rules/invariants/$rule.md"
done

if [ -f "$SCRIPT_DIR/global/reference/skills-cheatsheet.md" ]; then
  copy_file "$SCRIPT_DIR/global/reference/skills-cheatsheet.md" "$GLOBAL_TARGET/reference/skills-cheatsheet.md"
fi
echo ""

# --- B. Workspace layer -> ~/dev/ ---
echo "--- Workspace layer -> $WORKSPACE_TARGET/ ---"
copy_file "$SCRIPT_DIR/workspace/CLAUDE.md" "$WORKSPACE_TARGET/CLAUDE.md"

for rule in python typescript frontend api fleet migration; do
  copy_file "$SCRIPT_DIR/workspace/.claude/rules/contextual/$rule.md" "$WORKSPACE_TARGET/.claude/rules/contextual/$rule.md"
done

# Hooks
echo ""
echo "--- Hooks -> $WORKSPACE_TARGET/config/hooks/ ---"
for hook in LoadProjects ShowProjects SessionEndReminder AutoLint SafetyNet StopGate CompletionCheck AntiRationalization; do
  copy_file "$SCRIPT_DIR/workspace/config/hooks/${hook}.hook.ts" "$WORKSPACE_TARGET/config/hooks/${hook}.hook.ts"
done
copy_file "$SCRIPT_DIR/workspace/config/hooks/lib/log.ts"      "$WORKSPACE_TARGET/config/hooks/lib/log.ts"
copy_file "$SCRIPT_DIR/workspace/config/hooks/lib/paths.ts"    "$WORKSPACE_TARGET/config/hooks/lib/paths.ts"
copy_file "$SCRIPT_DIR/workspace/config/hooks/lib/projects.ts" "$WORKSPACE_TARGET/config/hooks/lib/projects.ts"
echo ""

# --- D. Repo CLAUDE.md files ---
echo "--- Repo CLAUDE.md files -> $REPO_BASE/<repo>/ ---"
for repo in command-centre context-engine data-layer aureus skills claude-mcp-server agent-memory sni-knowledge; do
  local_src="$SCRIPT_DIR/repo-claudes/$repo/CLAUDE.md"
  target_dir="$REPO_BASE/$repo"

  if [ ! -d "$target_dir" ] && ! $DRY_RUN; then
    log_warn "Repo directory does not exist, skipping: $target_dir"
    continue
  fi

  copy_file "$local_src" "$target_dir/CLAUDE.md"
done
echo ""

# --- C. Memory seed (optional) ---
if $WITH_MEMORY; then
  echo "--- Memory seed -> $MEMORY_TARGET/ ---"
  copy_file "$SCRIPT_DIR/memory-seed/MEMORIES.md" "$MEMORY_TARGET/MEMORIES.md"
  copy_dir  "$SCRIPT_DIR/memory-seed/projects"    "$MEMORY_TARGET/projects"
  copy_dir  "$SCRIPT_DIR/memory-seed/known-issues" "$MEMORY_TARGET/known-issues"
  echo ""
else
  echo "--- Memory seed: SKIPPED (use --with-memory to include) ---"
  echo ""
fi

# --- Summary ---
echo "=== Install complete ==="
echo "  Files copied:  $COPIED"
echo "  Files skipped: $SKIPPED"
echo "  Warnings:      $WARNED"
if $DRY_RUN; then
  echo ""
  echo "  This was a dry run. No files were actually copied."
fi
