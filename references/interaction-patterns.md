# Interaction Patterns

## Core Principle

**Always ask the user.** This plugin is interactive-first. Every significant decision gets user input via AskUserQuestion with selectable options.

## When to Prompt

| Situation | Prompt Type |
| --------- | ---------- |
| Brainstorm exploration (each round of the loop) | Clarify + offer next steps |
| Phase transition (research -> plan -> build -> verify) | Confirm proceed |
| Git commit | Approve message and files |
| Git push | Approve target |
| Agent dispatch | Show which agents, confirm |
| Plan review | Approve or modify |
| Verification findings | Choose: fix, defer, or ignore |
| Destructive action (delete, overwrite) | Explicit confirmation |
| Configuration change | Confirm new value |
| Branch merge | Choose: merge, PR, or leave |

## AskUserQuestion Format

Always use AskUserQuestion with selectable options for structured decisions:

```
Use AskUserQuestion:
- header: "Section Title"
- question: "Clear question?"
- options:
  - "Option A" - brief description
  - "Option B" - brief description
  - "Option C" - brief description
```

This renders as a selectable list the user can navigate with keyboard.

## Prompt Categories

### Confirmation Prompts (yes/no + escape hatch)
```
- "Yes, proceed"
- "No, stop"
- "Let me think" (pauses, saves state)
```

### Choice Prompts (pick one)
```
- "Option A" - description
- "Option B" - description
- "Option C" - description
- "Custom" - enter your own
```

### Review Prompts (approve with modifications)
```
- "Looks good, proceed"
- "Modify" - adjust before proceeding
- "Reject" - start over
- "Skip" - move on without this step
```

### Brainstorm Prompts (exploration loop)
```
- "[Specific suggestion A]" - contextual option
- "[Specific suggestion B]" - contextual option
- "Something else" - user types their own
- "Explore this further" - dig deeper
- "Consider alternatives" - different approaches
- "Narrow scope" - simplify
- "I'm ready - start building" - exit brainstorm
- "Save brainstorm notes" - save without starting
```

Brainstorm prompts are unique because the first few options are contextual - they change
every round based on the conversation. The last four options are always present as
navigation controls. One question per round, never a list.

## Fast Mode Differences

In fast mode, some prompts are skipped:
- Phase transitions auto-proceed (no confirmation)
- Research summaries are brief
- Verification only stops on CRITICAL findings

**Fast mode NEVER skips:**
- Git commit/push approval
- Destructive action confirmation
- Plan approval (always shown, but briefer)
- CRITICAL verification findings

## Dangerous Operations Warning

The following operations always show a warning banner before prompting:

```
⚠ DANGEROUS OPERATION
[Description of what will happen]
This action cannot be easily undone.
```

- Force push
- Branch deletion
- File deletion outside .work/
- Database migrations
- Production deployments
- Overwriting uncommitted changes
