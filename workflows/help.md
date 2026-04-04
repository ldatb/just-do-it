<purpose>
Display all available /do: commands with descriptions and current project state.
</purpose>

<process>

## 1. Show Command Reference

Display the following:

```
Just do It - Command Reference

QUICK START
  /do:start "task"        Begin or continue a project task.
  /do:it "task"           Execute immediately, no ceremony.
  /do:brainstorm "idea"   Explore an idea before committing to build.

TOOLS
  /do:debug "issue"       Investigate and fix a specific issue.
  /do:review "what"       Review code or decisions in context.

PROJECT
  /do:status              Show project state and resume options.
  /do:settings            View or change project configuration.
  /do:help                Show this help.
```

## 2. Show Current State (if available)

If `.work/STATE.md` exists, also show:

```
Current state:
  Project: <name from PROJECT.md>
  Phase:   <current phase>
  Step:    <current step>
  Next:    <next suggested action>
```

If `.work/STATE.md` does not exist, show:

```
No project initialized. Run /do:start "describe what to build" to begin.
```

</process>
