#!/bin/bash
set -euo pipefail

# Just do It - plugin uninstaller

CLAUDE_DIR="$HOME/.claude"
PLUGIN_DIR="$CLAUDE_DIR/do"
COMMANDS_DIR="$CLAUDE_DIR/commands/do"
CODEX_INSTRUCTIONS="$HOME/.codex/instructions.md"
CODEX_MARKER_START="<!-- BEGIN: just-do-it -->"
CODEX_MARKER_END="<!-- END: just-do-it -->"

echo ""
echo "  Just do It - uninstalling..."
echo ""

# ── Claude Code ────────────────────────────────────────────────────────────────

echo "  [Claude Code]"

for agent_file in "$CLAUDE_DIR/agents"/do-*.md; do
  if [ -f "$agent_file" ]; then
    rm "$agent_file"
  fi
done
echo "  Removed 26 agent definitions"

if [ -d "$COMMANDS_DIR" ]; then
  rm -rf "$COMMANDS_DIR"
  echo "  Removed 8 command files"
fi

if [ -d "$PLUGIN_DIR" ]; then
  rm -rf "$PLUGIN_DIR"
  echo "  Removed core files (workflows, templates, references)"
fi

# ── Codex ──────────────────────────────────────────────────────────────────────

echo ""
echo "  [Codex]"

if [ -f "$CODEX_INSTRUCTIONS" ] && grep -q "$CODEX_MARKER_START" "$CODEX_INSTRUCTIONS"; then
  awk -v start="$CODEX_MARKER_START" -v end="$CODEX_MARKER_END" \
      'BEGIN{skip=0} $0==start{skip=1; next} $0==end{skip=0; next} !skip{print}' \
      "$CODEX_INSTRUCTIONS" > "$CODEX_INSTRUCTIONS.tmp" && mv "$CODEX_INSTRUCTIONS.tmp" "$CODEX_INSTRUCTIONS"
  # Remove file if now empty (only whitespace)
  if [ -z "$(tr -d '[:space:]' < "$CODEX_INSTRUCTIONS")" ]; then
    rm "$CODEX_INSTRUCTIONS"
    echo "  Removed $CODEX_INSTRUCTIONS (was empty after removal)"
  else
    echo "  Removed just-do-it block from $CODEX_INSTRUCTIONS"
  fi
else
  echo "  Nothing to remove in Codex instructions"
fi

# ── Done ───────────────────────────────────────────────────────────────────────

echo ""
echo "  Uninstalled successfully."
echo ""
echo "  Note: .work/ directories in your projects are preserved."
echo "  Delete them manually if you no longer need the project state."
echo ""
