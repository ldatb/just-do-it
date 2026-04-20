<purpose>
View or modify project configuration. Flat menu, 2 levels max.
</purpose>

<process>

## 1. Load

Read `.work/config.json`. If `.work/` doesn't exist: error — no project initialized. Suggest `/do:start`.

## 2. Display and Menu (Level 1)

Display current config values:

```
model_profile:                      [value]
fast_mode:                          [value]
git.use_branches:                   [value]
git.auto_commit:                    [value]
verify.auto_fix.enabled:            [value]
verify.auto_fix.max_iterations:     [value]
parallelization.max_concurrent:     [value]
```

If any model_overrides exist, list each one:
```
Agent overrides:
  do-architect: opus
  do-security: opus
```

Then present the main settings menu:

Use AskUserQuestion:
- header: "Settings"
- question: "Select a setting to change, or Done to exit."
- options:
  - "model_profile: [current]" - cycle to next: balanced -> quality -> budget -> balanced
  - "fast_mode: [current]" - toggle to: [opposite]
  - "Git settings" - configure use_branches, auto_commit, and conventional_commits
  - "Verify settings" - configure auto_fix loop (enabled, max_iterations)
  - "Agent model overrides" - add or remove model overrides per agent
  - "Done" - save and exit settings

If existing model_overrides are present, they are managed through "Agent model overrides" (Level 2).

## 3. Handle Selection

### model_profile

Cycle to the next value in sequence: balanced -> quality -> budget -> balanced.
Apply immediately to config.json.
Print: `model_profile set to [new value]`
Return to Level 1 menu.

### fast_mode

Toggle the current boolean value.
Apply immediately to config.json.
Print: `fast_mode set to [new value]`
Return to Level 1 menu.

### Git settings (Level 2)

Display current git config values:
```
git.use_branches:        [value]
git.auto_commit:         [value]
git.conventional_commits: [value]
```

Use AskUserQuestion:
- header: "Settings: Git"
- question: "Select a git setting to toggle, or Done to return."
- options:
  - "git.use_branches: [current]" - toggle to: [opposite]; feature branch per phase
  - "git.auto_commit: [current]" - toggle to: [opposite]; auto-commit after each wave
  - "git.conventional_commits: [current]" - toggle to: [opposite]; enforce feat:/fix: prefix format
  - "Done" - return to main settings menu

When the user selects a toggle: apply to config.json immediately, print the updated value, re-present this Level 2 menu.
When the user selects "Done": return to Level 1 menu.

This is the final level for git settings. There is no Level 3.

### Verify settings (Level 2)

Display current verify config values:
```
verify.auto_fix.enabled:        [value]
verify.auto_fix.max_iterations: [value]
```

Use AskUserQuestion:
- header: "Settings: Verify"
- question: "Select a verify setting to change, or Done to return."
- options:
  - "verify.auto_fix.enabled: [current]" - toggle to: [opposite]; auto-dispatch do-coder to fix CRITICAL/HIGH findings in a loop
  - "verify.auto_fix.max_iterations: [current]" - cycle through 1 -> 3 -> 5 -> 10 -> 1; cap on auto-fix loop iterations
  - "Done" - return to main settings menu

When the user selects a toggle or cycle: apply to config.json immediately, print the updated value, re-present this Level 2 menu.
When the user selects "Done": return to Level 1 menu.

This is the final level for verify settings. There is no Level 3.

### Agent model overrides (Level 2)

Display existing overrides (if any):
```
Agent overrides:
  [agent]: [model]
  ...
```

Use AskUserQuestion:
- header: "Settings: Agent Overrides"
- question: "Add an override or remove an existing one."
- options:
  - "Add override" - set a specific model for one agent
  - "Remove [agent]: [model]" (one entry per existing override, up to 3)
  - "Done" - return to main settings menu

If there are more than 3 existing overrides, show only the first 3 and add "See all overrides" as an option.

**Add override:**

Use AskUserQuestion:
- header: "Settings: Agent Override"
- question: "Which agent should use a non-default model?"
- options:
  - "do-architect -> opus (Recommended)" - architecture decisions benefit from deep reasoning
  - "do-security -> opus" - security review warrants the strongest model
  - "do-coder -> haiku" - fast code generation at lower cost
  - "Other" - specify agent and model manually

When the user selects an option (not "Other"):
- Apply the override to config.json under `model_overrides`
- Print: `Override set: [agent] will use [model]`
- Return to Agent model overrides menu.

When the user selects "Other":
- Ask: which agent name and which model (haiku/sonnet/opus) — one focused question
- Apply and return to Agent model overrides menu.

**Remove [agent]: [model]:**

Remove that entry from `model_overrides` in config.json.
Print: `Override removed: [agent] will use profile default`
Return to Agent model overrides menu.

**Done:** Return to Level 1 menu.

This is the final level for overrides. There is no Level 3.

### Done

Exit settings. No further action.

</process>
