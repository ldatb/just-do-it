# Fast Mode

Fast mode reduces ceremony to get work done quickly. Toggle with `/do:settings fast_mode on`.

For the fastest experience, use `/do:it "task"` which enables fast mode automatically and skips most prompts.

## What Changes in Fast Mode

| Phase | Normal Mode | Fast Mode |
| ----- | ----------- | --------- |
| **Discover** | 4 parallel agents, detailed report | 1 agent, quick scan, essential facts only |
| **Research** | Deep research, multiple angles | Quick search, top 2-3 findings |
| **Plan** | Detailed PLAN.md with waves | Minimal plan, single wave, key tasks only |
| **Build** | Full execution with logging | Execute immediately, minimal BUILD.md |
| **Verify** | All relevant specialists | Only do-qa + do-reviewer (2 agents max) |

## What NEVER Changes (Even in Fast Mode)

- Git commit/push always requires user approval
- CRITICAL verification findings always stop execution
- Destructive actions always prompt
- Plan is always shown (even if brief) - user must approve
- STATE.md is always updated

## When to Use Fast Mode

- Small, well-understood changes
- Bug fixes with clear root cause
- Quick content updates
- Tasks where you already know the approach
- Iterating on feedback from a previous phase

## When NOT to Use Fast Mode

- Greenfield architecture decisions
- Security-sensitive changes
- Large refactors
- Unfamiliar codebase or technology
- Work that will be hard to undo
