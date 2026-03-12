<purpose>
Display all available /do: commands with descriptions and usage examples.
</purpose>

<process>

## 1. Show Command Reference

Display the following:

```
Just do It - Command Reference

QUICK START
  /do:go "task"           Just do it. Minimal ceremony, fast execution.
  /do:start "task"        Full pipeline: research, plan, build, verify.
  /do:brainstorm "topic"  Explore and refine an idea before building.

PIPELINE STEPS (standalone)
  /do:research "topic"    Research a topic, technology, or approach.
  /do:plan [phase]        Plan the current or specified phase.
  /do:build [phase]       Execute the current phase's plan.
  /do:verify [phase]      Multi-specialist verification of completed work.

PROJECT SETUP
  /do:discover            Scan codebase, generate agent context files.
  /do:setup               Interactive setup for new projects.

TOOLS
  /do:debug "issue"       Debug a bug with the specialist agent.
  /do:review [path|PR#]   Code review with specialist agents.

SESSION
  /do:status              Show current phase and next action.
  /do:resume              Continue from where you left off.
  /do:save                Save state for later resumption.
  /do:settings            Configure model profile, agents, git, mode.
  /do:help                Show this help.
```

## 2. Show Current State (if available)

If `.work/STATE.md` exists, also show:
- Current phase and step
- Next suggested action

</process>
