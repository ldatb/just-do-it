<purpose>
View or modify project configuration.
</purpose>

<process>

## 1. Load

Read `.work/config.json`. If `.work/` doesn't exist: error — no project initialized.

## 2. Menu

If $ARGUMENTS is empty: display current settings, then prompt.

Display current config.json values, then show each setting as a directly toggleable option:

Use AskUserQuestion:
- header: "Settings"
- question: "Current settings shown above. Select a setting to change:"
- options: one per setting, showing current value:
  - "model_profile: [current]" - cycle: balanced → quality → budget
  - "fast_mode: [current]" - toggle on/off
  - "git.use_branches: [current]" - toggle on/off
  - "git.conventional_commits: [current]" - toggle on/off
  - "git.auto_commit: [current]" - toggle on/off
  - "parallelization.max_concurrent: [current]" - set: 2/4/6/8
  - "model_overrides" - add or edit agent-specific model overrides
  - "Done" - exit settings

## 3. Handle Selection

When user selects a setting, show its specific options:

### model_profile
- "quality" - opus for critical agents, sonnet for rest
- "balanced" - sonnet for all (default)
- "budget" - haiku where possible

### fast_mode
Toggle: true ↔ false. Shorter research, quick verify, less ceremony.

### git.use_branches
Toggle: true ↔ false. Create feature branches per phase.

### git.conventional_commits
Toggle: true ↔ false. Use feat:, fix:, etc. format.

### git.auto_commit
Toggle: true ↔ false. Auto-commit after each wave.

### parallelization.max_concurrent
- "2" - conservative
- "4" - default
- "6" - aggressive
- "8" - maximum

### model_overrides
Show current overrides. Then:
- "Add override" - pick agent, then pick model (haiku/sonnet/opus)
- "Remove [agent]: [model]" - one option per existing override
- "Back" - return to main settings

After each change, show updated value and return to the main settings menu.

## 4. Apply

Update config.json. Show updated setting. Ask if more changes or done.

</process>
