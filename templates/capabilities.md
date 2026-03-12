# Just do It - Capabilities

This file describes what the plugin can do. Generated during setup/discover.

## Git Integration
<!-- Fill these from config.json during initialization -->
- **Auto-commit:** false (commits require user approval)
- **Branches:** true/false (creates feature branches per phase)
- **Conventional commits:** true (feat:, fix:, chore:, etc.)

## Mode
- **Interactive:** Always confirms before acting. User approves every step.
- **Fast:** Reduces ceremony. Research/verify steps are shortened.

## Agents Available
<!-- List enabled agents from config.json -->

## Commands
- `/do:go` - Just do it. Minimal ceremony, fast execution.
- `/do:start` - Full pipeline: research, plan, build, verify.
- `/do:brainstorm` - Explore and refine an idea before building.
- `/do:research` - Research a topic or technology.
- `/do:plan` - Plan the current phase.
- `/do:build` - Execute the current phase's plan.
- `/do:verify` - Multi-specialist verification.
- `/do:debug` - Debug an issue with specialist agent.
- `/do:review` - Code review with specialists.
- `/do:discover` - Scan codebase, generate agent context.
- `/do:setup` - Interactive setup for new projects.
- `/do:status` - Show current phase and next action.
- `/do:resume` - Continue from where you left off.
- `/do:save` / `/do:pause` - Save state for later.
- `/do:settings` - Configure profiles, agents, git, mode.
- `/do:help` - Show command reference.

## Phases
- **Discover** - Deep codebase scan, generate agent context files
- **Research** - Find prior art, libraries, patterns
- **Plan** - Create executable task plan
- **Build** - Specialist agents execute tasks
- **Verify** - Multi-specialist review

## Model Profiles
- **quality** - Best output, highest cost (opus for critical agents)
- **balanced** - Good results, reasonable cost (default)
- **budget** - Fast and cheap (haiku for most agents)

## Safety
- All git operations require user confirmation
- No autonomous mode - user is always in the loop
- Destructive actions (file deletion, force push) always prompt
- CRITICAL verification findings block completion
