<purpose>
View or modify project configuration. Always interactive - uses selectable options.
</purpose>

<process>

## 1. Load Config

Read `.work/config.json`.

**If `.work/` doesn't exist:** Error - no project initialized.

## 2. Parse Arguments

If $ARGUMENTS is empty: display current settings in a formatted view, then prompt.

Use AskUserQuestion:
- header: "Settings"
- question: "What would you like to change?"
- options:
  - "Model profile" - change quality/balanced/budget
  - "Fast mode" - toggle fast mode on/off
  - "Git workflow" - branches, commits, auto-commit
  - "Agents" - enable/disable specific agents
  - "Parallelization" - adjust max concurrent agents
  - "View all" - show current config.json
  - "Done" - exit settings

## 3. Handle Selection

### Model Profile

Use AskUserQuestion:
- header: "Model Profile"
- question: "Current: [current]. Select new profile:"
- options:
  - "quality" - opus for critical agents, highest cost
  - "balanced" - sonnet for most, reasonable cost
  - "budget" - haiku for most, lowest cost

### Fast Mode

Use AskUserQuestion:
- header: "Fast Mode"
- question: "Current: [on/off]. Fast mode reduces ceremony - shorter research, quick verify."
- options:
  - "On" - enable fast mode
  - "Off" - disable fast mode

### Git Workflow

Use AskUserQuestion:
- header: "Git Workflow"
- question: "Current git settings: [summary]"
- options:
  - "Branches + conventional commits" - full git workflow
  - "Commits only" - no branches, just conventional commits
  - "No git" - don't touch git
  - "Toggle auto-commit" - auto-commit planning docs

### Agents

Show current agent status (enabled/disabled).

Use AskUserQuestion:
- header: "Toggle Agent"
- question: "Which agent to toggle?"
- options: [list of all agents with current status]

### Parallelization

Use AskUserQuestion:
- header: "Max Concurrent Agents"
- question: "Current: [N]. How many agents in parallel?"
- options:
  - "2" - conservative
  - "4" - default
  - "6" - aggressive
  - "8" - maximum

## 4. Apply Changes

Update `.work/config.json` with the new value.
Update `.work/capabilities.md` if relevant.

## 5. Confirm

Show the updated setting to the user.

Use AskUserQuestion:
- header: "Settings Updated"
- question: "Change more settings?"
- options:
  - "Yes" - back to settings menu
  - "Done" - exit settings

</process>
