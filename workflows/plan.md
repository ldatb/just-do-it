<purpose>
Plan the current or specified phase. Creates PLAN.md with tasks, waves, and success criteria.
</purpose>

<process>

## 1. Load Context

1. Read `.work/STATE.md` for current position
2. Read `.work/PROJECT.md` for project context
3. Read `.work/config.json` for settings
4. Determine which phase to plan:
   - If $ARGUMENTS contains a phase number, use that
   - Otherwise, use current phase from STATE.md

## 2. Read Phase Context

Read the phase directory `.work/phases/XX-<name>/`:
- `RESEARCH.md` if it exists (research findings)
If no research exists, do a quick research pass first (dispatch `do-researcher`).

## 3. Create Plan

Create `PLAN.md` in the phase directory with:

1. **Goal:** One sentence - what this phase delivers
2. **Requirements Covered:** REQ-IDs from PROJECT.md
3. **Tasks by Wave:**
   - Wave 1: Tasks that can run in parallel
   - Wave 2+: Tasks that depend on previous waves
   - Each task has: agent, files, action, verify, done
4. **Success Criteria:** How we know the phase is complete

## 4. Present Plan

Show the plan to the user. Ask for approval or modifications.

## 5. Update State

Update STATE.md:
- Step: plan
- Status: complete (or awaiting approval)
- Next Action: "Build phase XX" or "Revise plan"

</process>
