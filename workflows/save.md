<purpose>
Save current work state for later resumption. Config-driven: auto-commits if configured.
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

If `git.conventional_commits` is true, auto-commit state files:

```bash
git add .work/STATE.md .work/PROJECT.md .work/config.json
git add .work/phases/*/RESEARCH.md .work/phases/*/PLAN.md .work/phases/*/BUILD.md .work/phases/*/VERIFY.md
git commit -m "chore: save work state - phase XX step"
```

Never use `git add .work/` - stage specific files to avoid committing backups, temp files, or secrets.

## 4. Confirm

Tell user: "State saved. Resume anytime with `/do:resume`."

</process>
