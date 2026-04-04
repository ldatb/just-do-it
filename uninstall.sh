#!/bin/bash
set -euo pipefail

# Just do It - plugin uninstaller

CLAUDE_DIR="$HOME/.claude"
PLUGIN_DIR="$CLAUDE_DIR/do"
COMMANDS_DIR="$CLAUDE_DIR/commands/do"

echo ""
echo "  Just do It - uninstalling..."
echo ""

# Remove agent files
for agent_file in "$CLAUDE_DIR/agents"/do-*.md; do
  if [ -f "$agent_file" ]; then
    rm "$agent_file"
  fi
done
echo "  Removed 26 agent definitions"

# Remove commands directory
if [ -d "$COMMANDS_DIR" ]; then
  rm -rf "$COMMANDS_DIR"
  echo "  Removed 8 command files"
fi

# Remove plugin directory
if [ -d "$PLUGIN_DIR" ]; then
  rm -rf "$PLUGIN_DIR"
  echo "  Removed core files (workflows, templates, references)"
fi

echo ""
echo "  Uninstalled successfully."
echo ""
echo "  Note: .work/ directories in your projects are preserved."
echo "  Delete them manually if you no longer need the project state."
echo ""
