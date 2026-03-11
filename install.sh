#!/bin/bash
set -euo pipefail

# Just do It - plugin installer
# Copies agents, commands, and core files to ~/.claude/

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
PLUGIN_DIR="$CLAUDE_DIR/do"
AGENTS_DIR="$CLAUDE_DIR/agents"
COMMANDS_DIR="$CLAUDE_DIR/commands/do"

echo ""
echo "  Just do It - installing..."
echo ""

# Create directories
mkdir -p "$PLUGIN_DIR"
mkdir -p "$AGENTS_DIR"
mkdir -p "$COMMANDS_DIR"

# Copy core plugin files (workflows, templates, references)
echo "  Copying core files to $PLUGIN_DIR/"
cp -r "$SCRIPT_DIR/workflows" "$PLUGIN_DIR/"
cp -r "$SCRIPT_DIR/templates" "$PLUGIN_DIR/"
cp -r "$SCRIPT_DIR/references" "$PLUGIN_DIR/"

# Copy agent definitions to ~/.claude/agents/
echo "  Copying agents to $AGENTS_DIR/"
for agent_file in "$SCRIPT_DIR/agents/"*.md; do
  cp "$agent_file" "$AGENTS_DIR/"
  echo "    $(basename "$agent_file")"
done

# Copy and rewrite command files to ~/.claude/commands/do/
# Replace relative @workflows/ references with absolute paths
echo "  Copying commands to $COMMANDS_DIR/"
for cmd_file in "$SCRIPT_DIR/commands/"*.md; do
  filename="$(basename "$cmd_file")"
  sed "s|@workflows/|@$PLUGIN_DIR/workflows/|g; s|@references/|@$PLUGIN_DIR/references/|g" \
    "$cmd_file" > "$COMMANDS_DIR/$filename"
  echo "    $filename"
done

# Write version file
echo "0.1.0" > "$PLUGIN_DIR/VERSION"

echo ""
echo "  Installed successfully."
echo ""
echo "  Commands:"
echo "    /do:brainstorm - Brainstorm what to build before starting"
echo "    /do:start      - Full pipeline (research -> plan -> build -> verify)"
echo "    /do:discover   - Scan existing codebase, generate project context"
echo "    /do:setup      - Interactive project setup for new projects"
echo "    /do:plan       - Plan a phase"
echo "    /do:build      - Build a phase"
echo "    /do:verify     - Verify a phase"
echo "    /do:review     - Multi-specialist code review"
echo "    /do:status     - Current position"
echo "    /do:resume     - Resume from saved state"
echo "    /do:save       - Save state for later"
echo "    /do:settings   - Configure profiles, agents, etc."
echo ""
echo "  For existing codebases:  /do:discover"
echo "  For new projects:        /do:setup"
echo "  To start working:        /do:start \"description\""
echo ""
