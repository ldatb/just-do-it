<purpose>
Internal workflow — invoked by other workflows for state persistence. The /do:save command has been removed.

Save current work state for later resumption. Config-driven: auto-commits if configured.
Called internally by status.md and start.md. Users do not invoke this directly; state saves
automatically throughout execution.
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

If `git.auto_commit` is true, auto-commit state files:
- Print: "Auto-committing: chore: save work state - <phase> <step> (<N> files)..."

```bash
git add .work/STATE.md .work/PROJECT.md .work/config.json
git add .work/phases/*/RESEARCH.md .work/phases/*/PLAN.md .work/phases/*/BUILD.md .work/phases/*/VERIFY.md
git commit -m "chore: save work state - phase XX step"
```

Never use `git add .work/` - stage specific files to avoid committing backups, temp files, or secrets.

## 4. Confirm

Tell the caller (or user if invoked directly): "State saved."

</process>
