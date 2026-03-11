# Just do It - Capabilities

This file describes what the plugin can do. Generated during setup/discover.

## Git Integration
- **Auto-commit:** {{AUTO_COMMIT}} (commits planning docs automatically)
- **Branches:** {{USE_BRANCHES}} (creates feature branches per phase)
- **Branch prefix:** {{BRANCH_PREFIX}}
- **Conventional commits:** {{CONVENTIONAL_COMMITS}} (feat:, fix:, chore:, etc.)

## Mode
- **Interactive:** Always confirms before acting. User approves every step.
- **Fast:** Reduces ceremony. Research/verify steps are shortened or skipped.

## Agents Available
{{AGENT_LIST}}

## Phases
- **Discover** - Scan existing codebase (brownfield only)
- **Setup** - Interactive project configuration
- **Research** - Find prior art, libraries, patterns
- **Plan** - Create executable task plan
- **Build** - Specialist agents execute tasks
- **Verify** - Multi-specialist review

## Model Profiles
- **quality** - Best output, highest cost (opus for critical agents)
- **balanced** - Good results, reasonable cost (default)
- **budget** - Fast and cheap (haiku for most agents)

## Dangerous Operations
- All git operations require user confirmation
- No autonomous mode - user is always in the loop
- Destructive actions (file deletion, force push) always prompt

## Session Management
- `/do:save` - Save state to .work/STATE.md
- `/do:resume` - Continue from saved state
- `/do:status` - Check current position
