#!/bin/bash
set -euo pipefail

# Just do It - plugin installer
# Copies agents, commands, and core files to ~/.claude/ (Claude Code)
# Copies AGENTS.md to ~/.codex/instructions.md (Codex)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── Claude Code ────────────────────────────────────────────────────────────────

CLAUDE_DIR="$HOME/.claude"
PLUGIN_DIR="$CLAUDE_DIR/do"
AGENTS_DIR="$CLAUDE_DIR/agents"
COMMANDS_DIR="$CLAUDE_DIR/commands/do"

echo ""
echo "  Just do It - installing..."
echo ""
echo "  [Claude Code]"

mkdir -p "$PLUGIN_DIR"
mkdir -p "$AGENTS_DIR"
mkdir -p "$COMMANDS_DIR"

echo "  Copying core files to $PLUGIN_DIR/"
cp -r "$SCRIPT_DIR/workflows" "$PLUGIN_DIR/"
cp -r "$SCRIPT_DIR/templates" "$PLUGIN_DIR/"
cp -r "$SCRIPT_DIR/references" "$PLUGIN_DIR/"

echo "  Copying 26 agents to $AGENTS_DIR/"
for agent_file in "$SCRIPT_DIR/agents/"*.md; do
  cp "$agent_file" "$AGENTS_DIR/"
done

echo "  Copying 8 commands to $COMMANDS_DIR/"
for cmd_file in "$SCRIPT_DIR/commands/"*.md; do
  filename="$(basename "$cmd_file")"
  sed "s|@workflows/|@$PLUGIN_DIR/workflows/|g; s|@references/|@$PLUGIN_DIR/references/|g" \
    "$cmd_file" > "$COMMANDS_DIR/$filename"
done

echo "1.2.0" > "$PLUGIN_DIR/VERSION"

# ── Codex ──────────────────────────────────────────────────────────────────────

CODEX_DIR="$HOME/.codex"
CODEX_INSTRUCTIONS="$CODEX_DIR/instructions.md"
CODEX_MARKER_START="<!-- BEGIN: just-do-it -->"
CODEX_MARKER_END="<!-- END: just-do-it -->"

echo ""
echo "  [Codex]"

mkdir -p "$CODEX_DIR"

AGENTS_CONTENT="$CODEX_MARKER_START
$(cat "$SCRIPT_DIR/codex/AGENTS.md")
$CODEX_MARKER_END"

if [ -f "$CODEX_INSTRUCTIONS" ]; then
  if grep -q "$CODEX_MARKER_START" "$CODEX_INSTRUCTIONS"; then
    # Update existing block using awk
    awk -v start="$CODEX_MARKER_START" -v end="$CODEX_MARKER_END" \
        -v content="$AGENTS_CONTENT" \
        'BEGIN{skip=0} $0==start{print content; skip=1; next} $0==end{skip=0; next} !skip{print}' \
        "$CODEX_INSTRUCTIONS" > "$CODEX_INSTRUCTIONS.tmp" && mv "$CODEX_INSTRUCTIONS.tmp" "$CODEX_INSTRUCTIONS"
    echo "  Updated existing block in $CODEX_INSTRUCTIONS"
  else
    printf "\n%s\n" "$AGENTS_CONTENT" >> "$CODEX_INSTRUCTIONS"
    echo "  Appended to $CODEX_INSTRUCTIONS"
  fi
else
  printf "%s\n" "$AGENTS_CONTENT" > "$CODEX_INSTRUCTIONS"
  echo "  Created $CODEX_INSTRUCTIONS"
fi

# ── Done ───────────────────────────────────────────────────────────────────────

echo ""
echo "  Installed successfully."
echo ""
echo "  Claude Code commands:"
echo "    /do:start \"task\"      Full pipeline: research, plan, build, verify"
echo "    /do:it \"task\"         Execute immediately, no ceremony"
echo "    /do:brainstorm \"idea\" Explore and refine before building"
echo "    /do:debug \"issue\"     Investigate and fix a bug"
echo "    /do:review \"target\"   Multi-specialist code review"
echo "    /do:status             Show project state, navigate, resume"
echo "    /do:settings           Configure model profile, git, agents"
echo "    /do:help               Show all commands"
echo ""
echo "  Codex triggers:"
echo "    do start: <task>      Full pipeline"
echo "    do it: <task>         Execute immediately"
echo "    do brainstorm: <idea> Explore and refine"
echo "    do debug: <issue>     Investigate and fix"
echo "    do review: <target>   Multi-specialist review"
echo "    do status             Show project state"
echo ""
echo "  Get started (Claude Code):  /do:start \"description of what to build\""
echo "  Get started (Codex):        do start: description of what to build"
echo ""
