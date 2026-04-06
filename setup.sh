#!/usr/bin/env bash
# claude-memory setup script
# Creates your personal memory files from templates

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATES="$SCRIPT_DIR/templates"

echo "Setting up claude-memory..."

# Create personal files from templates (skip if they already exist)
for file in MEMORIES.md; do
  if [ ! -f "$SCRIPT_DIR/$file" ]; then
    cp "$TEMPLATES/$file" "$SCRIPT_DIR/$file"
    echo "  Created $file"
  else
    echo "  Skipped $file (already exists)"
  fi
done

# Create directories
for dir in projects known-issues; do
  mkdir -p "$SCRIPT_DIR/$dir"
  if [ ! "$(ls -A "$SCRIPT_DIR/$dir" 2>/dev/null)" ]; then
    cp "$TEMPLATES/$dir/_template.md" "$SCRIPT_DIR/$dir/_template.md"
    echo "  Created $dir/_template.md"
  else
    echo "  Skipped $dir/ (already has files)"
  fi
done

echo ""
echo "Done! Your memory files are ready."
echo ""
echo "Next steps:"
echo "  1. Edit MEMORIES.md — fill in your name, role, and preferences"
echo "  2. Create your first project: cp templates/projects/_template.md projects/my-project.md"
echo ""
echo "Point Claude Code to this directory by adding to ~/.claude/settings.json:"
echo "  \"env\": { \"MEMORY_DIR\": \"$SCRIPT_DIR\" }"
