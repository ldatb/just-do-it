<purpose>
Show current project status: position in workflow, phase progress, and what to do next.
</purpose>

<process>

## 1. Check Project Exists

Check if `.work/` directory exists.

**If not:** Inform user no project is initialized. Suggest `/do:start`.

## 2. Load State

1. Read `.work/STATE.md`
2. Read `.work/PROJECT.md`
3. List phase directories in `.work/phases/`

## 3. Display Status

Show a concise status report:

```
Project: <name from PROJECT.md>
Phase: XX-<name> (step: <current step>)
Status: <status>

Phases:
  [x] 01-<name> - complete
  [>] 02-<name> - in progress (build)
  [ ] 03-<name> - pending

Next: <next action from STATE.md>
```

## 4. Show Pending Items

If STATE.md has pending items, list them.

</process>
