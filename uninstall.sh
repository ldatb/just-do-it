#!/bin/bash
set -euo pipefail

# do plugin uninstaller

CLAUDE_DIR="$HOME/.claude"
PLUGIN_DIR="$CLAUDE_DIR/do"
COMMANDS_DIR="$CLAUDE_DIR/commands/do"

echo "Uninstalling 'do' plugin..."

# Remove agent files
for agent_file in "$CLAUDE_DIR/agents"/do-*.md; do
  if [ -f "$agent_file" ]; then
    rm "$agent_file"
    echo "  Removed $(basename "$agent_file")"
  fi
done

# Remove commands directory
if [ -d "$COMMANDS_DIR" ]; then
  rm -rf "$COMMANDS_DIR"
  echo "  Removed commands/do/"
fi

# Remove plugin directory
if [ -d "$PLUGIN_DIR" ]; then
  rm -rf "$PLUGIN_DIR"
  echo "  Removed do/"
fi

echo ""
echo "Uninstalled successfully."
echo "Note: .work/ directories in your projects are NOT removed."
