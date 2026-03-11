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

When `/do:resume` is invoked:
1. Read `.work/STATE.md`
2. Read `.work/PROJECT.md` for project context
3. Read the current phase directory for phase-specific state
4. Continue from `Next Action`

## Pause Protocol

When `/do:pause` or session ends:
1. Update STATE.md with current position
2. Write `Next Action` clearly
3. List any in-flight work
4. Commit planning docs if git is available
