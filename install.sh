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
echo "  Copying 26 agents to $AGENTS_DIR/"
for agent_file in "$SCRIPT_DIR/agents/"*.md; do
  cp "$agent_file" "$AGENTS_DIR/"
done

# Copy and rewrite command files to ~/.claude/commands/do/
# Replace relative @workflows/ references with absolute paths
echo "  Copying 8 commands to $COMMANDS_DIR/"
for cmd_file in "$SCRIPT_DIR/commands/"*.md; do
  filename="$(basename "$cmd_file")"
  sed "s|@workflows/|@$PLUGIN_DIR/workflows/|g; s|@references/|@$PLUGIN_DIR/references/|g" \
    "$cmd_file" > "$COMMANDS_DIR/$filename"
done

# Write version file
echo "1.1.0" > "$PLUGIN_DIR/VERSION"

echo ""
echo "  Installed successfully."
echo ""
echo "  Commands:"
echo "    /do:start \"task\"      Full pipeline: research, plan, build, verify"
echo "    /do:it \"task\"         Execute immediately, no ceremony"
echo "    /do:brainstorm \"idea\" Explore and refine before building"
echo "    /do:debug \"issue\"     Investigate and fix a bug"
echo "    /do:review \"target\"   Multi-specialist code review"
echo "    /do:status             Show project state, navigate, resume"
echo "    /do:settings           Configure model profile, git, agents"
echo "    /do:help               Show all commands"
echo ""
echo "  Get started:"
echo "    /do:start \"description of what to build\""
echo ""
