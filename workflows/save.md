<purpose>
Save current work state for later resumption.
</purpose>

<process>

## 1. Capture State

1. Read `.work/STATE.md`
2. Determine current position precisely:
   - Which phase
   - Which step (research, plan, build, verify)
   - Which wave/task if mid-build
   - Any in-flight work

## 2. Update STATE.md

Write to STATE.md:
- Current Position (phase, step, status: saved)
- Last Updated: current timestamp
- Last Action: what was just completed
- Next Action: exactly what to do when resuming
- Context: any decisions or state from this session
- Pending: incomplete items

## 3. Git (if configured)

Read `.work/config.json` for git settings.

If `git.auto_commit` is true:

Use AskUserQuestion to confirm:
- header: "Save to Git"
- question: "Commit .work/ state to git?"
- options:
  - "Yes" - commit planning docs
  - "No" - save locally only

If confirmed:
```bash
git add .work/
git commit -m "chore: save work state - phase XX step"
```

## 4. Confirm

Tell user: "State saved. Resume anytime with `/do:resume`."

</process>
