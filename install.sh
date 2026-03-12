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
echo "0.2.0" > "$PLUGIN_DIR/VERSION"

echo ""
echo "  Installed successfully."
echo ""
echo "  Quick Start:"
echo "    /do:it \"task\"     - Just do it. Minimal ceremony."
echo "    /do:start \"task\"  - Full pipeline (research, plan, build, verify)"
echo "    /do:help          - Show all commands"
echo ""
echo "  New Commands:"
echo "    /do:it            - Just do it. Skip ceremony, fast execution."
echo "    /do:debug         - Debug an issue with specialist agent."
echo "    /do:research      - Research a topic before implementing."
echo "    /do:help          - Show all commands and usage."
echo "    /do:pause         - Alias for /do:save."
echo ""
echo "  All Commands:"
echo "    /do:brainstorm    - Explore and refine an idea"
echo "    /do:start         - Full pipeline"
echo "    /do:it            - Fast execution"
echo "    /do:discover      - Deep codebase scan"
echo "    /do:setup         - Interactive setup"
echo "    /do:research      - Standalone research"
echo "    /do:plan          - Plan a phase"
echo "    /do:build         - Build a phase"
echo "    /do:verify        - Verify a phase"
echo "    /do:debug         - Debug an issue"
echo "    /do:review        - Code review"
echo "    /do:status        - Current position"
echo "    /do:resume        - Resume from saved state"
echo "    /do:save/pause    - Save state"
echo "    /do:settings      - Configure profiles"
echo "    /do:help          - Command reference"
echo ""
echo "  For existing codebases:  /do:discover"
echo "  For new projects:        /do:setup"
echo "  To start working:        /do:start \"description\""
echo "  To just do it:           /do:it \"description\""
echo ""
