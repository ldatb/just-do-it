<purpose>
View or modify project configuration.
</purpose>

<process>

## 1. Load

Read `.work/config.json`. If `.work/` doesn't exist: error — no project initialized.

## 2. Menu

If $ARGUMENTS is empty: display current settings, then prompt.

Use AskUserQuestion:
- header: "Settings"
- question: "What would you like to change?"
- options:
  - "Model profile" - quality/balanced/budget
  - "Fast mode" - on/off
  - "Git workflow" - branches, commits, auto-commit
  - "Parallelization" - max concurrent agents
  - "View all" - show config.json
  - "Done" - exit

## 3. Handle Selection

### Model Profile
Options: quality (opus for critical agents) / balanced (sonnet, default) / budget (haiku)

### Fast Mode
Toggle on/off. Fast mode: shorter research, quick verify, less ceremony.

### Git Workflow
Options:
- "Branches + conventional commits" (full)
- "Commits only" (no branches)
- "No git" (hands off)
- "Toggle auto-commit" (auto-commit after each wave)

### Parallelization
Options: 2 (conservative) / 4 (default) / 6 (aggressive) / 8 (maximum)

## 4. Apply

Update config.json. Show updated setting. Ask if more changes or done.

</process>
