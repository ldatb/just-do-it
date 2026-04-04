# Just do It - Capabilities

This file describes what the plugin can do. Generated during initialization.

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
- `/do:start` - Begin or continue a project task
- `/do:it` - Execute immediately, no ceremony
- `/do:brainstorm` - Explore an idea before building
- `/do:debug` - Investigate and fix a bug
- `/do:review` - Review code with specialists
- `/do:status` - Show project state and navigate
- `/do:settings` - Configure project settings
- `/do:help` - Show command reference

## Phases
- **Initialize** - First-run setup and codebase discovery (internal, triggered by start)
- **Research** - Find prior art, libraries, patterns
- **Plan** - Create executable task plan
- **Build** - Specialist agents execute tasks
- **Verify** - Multi-specialist review

## Model Profiles
- **quality** - Best output, highest cost (opus for critical agents)
- **balanced** - Good results, reasonable cost (default)
- **budget** - Fast and cheap (haiku for most agents)

## Safety
- Git operations follow config settings (auto_commit controls commit behavior)
- No autonomous mode - user is always in the loop
- Destructive actions (file deletion, force push) always prompt
- CRITICAL verification findings block completion
