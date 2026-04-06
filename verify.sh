#!/usr/bin/env bash
# verify.sh — Verify the bootstrap repo structure and contents
#
# Checks that required files, directories, and scripts are present.
# Prints PASS / WARN / FAIL for each check.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

pass() { echo "  PASS: $1"; PASS_COUNT=$((PASS_COUNT + 1)); }
warn() { echo "  WARN: $1"; WARN_COUNT=$((WARN_COUNT + 1)); }
fail() { echo "  FAIL: $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

check_file() {
  local path="$1"
  local required="${2:-true}"
  local label="${3:-$path}"

  if [ -f "$SCRIPT_DIR/$path" ]; then
    pass "$label"
  elif [ "$required" = "true" ]; then
    fail "$label (missing)"
  else
    warn "$label (optional, missing)"
  fi
}

check_dir() {
  local path="$1"
  local required="${2:-true}"
  local label="${3:-$path}"

  if [ -d "$SCRIPT_DIR/$path" ]; then
    pass "$label"
  elif [ "$required" = "true" ]; then
    fail "$label (missing)"
  else
    warn "$label (optional, missing)"
  fi
}

check_executable() {
  local path="$1"
  local label="${2:-$path}"

  if [ -x "$SCRIPT_DIR/$path" ]; then
    pass "$label (executable)"
  elif [ -f "$SCRIPT_DIR/$path" ]; then
    warn "$label (exists but not executable)"
  else
    fail "$label (missing)"
  fi
}

echo "=== Claude Code Bootstrap Verification ==="
echo ""

# --- Top-level files ---
echo "--- Top-level files ---"
check_file "README.md"
check_file "manifest.md"
check_file "EXCLUDED.md"
check_file "bootstrap.config.example"
check_file ".gitignore"
echo ""

# --- Scripts ---
echo "--- Scripts ---"
check_executable "install.sh"
check_executable "sync-from-machine.sh"
check_executable "verify.sh"
echo ""

# --- Global layer ---
echo "--- Global layer ---"
check_file "global/CLAUDE.md"
check_file "global/settings.json"
check_file "global/commands/resume.md"
check_file "global/commands/wrapup.md"
check_file "global/commands/reflect.md"
check_file "global/commands/audit.md"
check_file "global/commands/design.md"
check_file "global/rules/invariants/package-managers.md"
check_file "global/rules/invariants/database.md"
check_file "global/rules/invariants/safety.md"
check_file "global/reference/skills-cheatsheet.md" "false" "global/reference/skills-cheatsheet.md"
echo ""

# --- Workspace layer ---
echo "--- Workspace layer ---"
check_file "workspace/CLAUDE.md"
check_file "workspace/.claude/rules/contextual/python.md"
check_file "workspace/.claude/rules/contextual/typescript.md"
check_file "workspace/.claude/rules/contextual/frontend.md"
check_file "workspace/.claude/rules/contextual/api.md"
check_file "workspace/.claude/rules/contextual/fleet.md"
check_file "workspace/.claude/rules/contextual/migration.md"
echo ""

# --- Hooks ---
echo "--- Hooks ---"
for hook in LoadProjects ShowProjects SessionEndReminder AutoLint SafetyNet StopGate CompletionCheck AntiRationalization; do
  check_file "workspace/config/hooks/${hook}.hook.ts"
done
check_file "workspace/config/hooks/lib/log.ts"
check_file "workspace/config/hooks/lib/paths.ts"
echo ""

# --- Repo CLAUDE.md files ---
echo "--- Repo CLAUDE.md files ---"
for repo in command-centre context-engine data-layer aureus skills claude-mcp-server agent-memory sni-knowledge; do
  check_file "repo-claudes/$repo/CLAUDE.md"
done
echo ""

# --- Optional: Memory seed ---
echo "--- Memory seed (optional — gitignored) ---"
check_file "memory-seed/MEMORIES.md" "false" "memory-seed/MEMORIES.md"
check_dir  "memory-seed/projects"    "false" "memory-seed/projects/"
check_dir  "memory-seed/known-issues" "false" "memory-seed/known-issues/"
echo ""

# --- Optional: Templates and examples ---
echo "--- Templates and examples (optional) ---"
check_dir  "templates"  "false" "templates/"
check_dir  "examples"   "false" "examples/"
echo ""

# --- Summary ---
echo "=== Verification Summary ==="
echo "  PASS: $PASS_COUNT"
echo "  WARN: $WARN_COUNT"
echo "  FAIL: $FAIL_COUNT"
echo ""

if [ "$FAIL_COUNT" -gt 0 ]; then
  echo "RESULT: FAIL — $FAIL_COUNT required items missing"
  exit 1
elif [ "$WARN_COUNT" -gt 0 ]; then
  echo "RESULT: PASS with $WARN_COUNT warnings"
  exit 0
else
  echo "RESULT: PASS — all checks passed"
  exit 0
fi
