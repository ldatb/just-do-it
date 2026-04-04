# Session Continuity

## How It Works

All state lives in `.work/STATE.md`. When a session ends or pauses, STATE.md contains everything needed to resume.

## STATE.md Structure

```markdown
# State

## Current Position
- Phase: XX-name
- Step: research|plan|build|verify|done
- Status: in-progress|paused|blocked|complete

## Session
- Last Updated: ISO timestamp
- Last Action: what was done
- Next Action: what to do next

## Context
- Key decisions made this session
- Blockers encountered
- Files modified

## Pending
- [ ] Incomplete items
- [ ] Things to verify
```

## Resume Protocol

To resume work, run `/do:start` or `/do:status`:

- `/do:start` — reads STATE.md, displays a context block, and presents navigation options to continue from the last saved position.
- `/do:status` — reads STATE.md and PROJECT.md, shows current position and phase list, and offers navigation options.

Resume steps:
1. Read `.work/STATE.md`
2. Read `.work/PROJECT.md` for project context
3. Read the current phase directory for phase-specific state
4. Continue from `Next Action`

## Pause Protocol

State saves automatically — there is no manual pause command. STATE.md is updated at every significant transition during execution. To stop working, simply close Claude Code.

Automatic save behavior:
1. STATE.md is updated with current position after each significant action
2. `Next Action` is written clearly so execution can resume from the exact point
3. In-flight work is listed under `Pending`
4. If `git.auto_commit` is true in config.json, planning docs are committed automatically
