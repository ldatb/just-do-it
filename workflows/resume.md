<purpose>
Resume work from the last saved session state.
</purpose>

<process>

## 1. Load State

1. Read `.work/STATE.md`
2. Read `.work/PROJECT.md`
3. Read the current phase directory

**If `.work/` doesn't exist:** Error - no project to resume. Suggest `/do:start`.

## 2. Display Context

Show the user:
- Project name and description
- Current phase and step
- Last action taken
- Next action planned
- Any pending items

## 3. Resume

Based on STATE.md `Next Action`:

- If next action is "Research phase XX" -> Run research workflow
- If next action is "Plan phase XX" -> Run plan workflow
- If next action is "Build phase XX" -> Run build workflow
- If next action is "Verify phase XX" -> Run verify workflow
- If next action is "Fix issues" -> Show VERIFY.md findings, start fixing
- If next action is "Start next phase" -> Create next phase directory, run start

Ask user: "Continue with: <next action>?"

## 4. Execute

Proceed with the appropriate workflow step.

</process>
