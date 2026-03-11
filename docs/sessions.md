# Session Management - Full Documentation

## Overview

The "do" plugin maintains project state across Claude Code sessions using markdown files in the `.work/` directory. This enables you to start work, pause, close Claude Code, reopen it later, and resume exactly where you left off.

## How It Works

### State Architecture

```
.work/
├── PROJECT.md   ← Stable project definition (changes rarely)
├── STATE.md     ← Session state (changes every action)
├── config.json  ← Settings (changes on user request)
└── phases/      ← Phase-specific state
    └── XX-name/
        ├── RESEARCH.md  ← Research findings
        ├── PLAN.md      ← Execution plan
        ├── BUILD.md     ← Build log
        └── VERIFY.md    ← Verification results
```

**STATE.md** is the critical file. It contains everything needed to resume work:

```markdown
# State

## Current Position
- Phase: 02-auth
- Step: build
- Status: in-progress

## Session
- Last Updated: 2026-03-11T14:30:00Z
- Last Action: Completed Wave 1 of build (do-coder implemented login endpoint)
- Next Action: Execute Wave 2 (do-security hardens auth, do-coder adds session management)

## Context
- Decided to use JWT tokens over session cookies (simpler for API consumers)
- Using bcrypt for password hashing (RESEARCH.md recommendation)
- PostgreSQL schema already exists from Phase 01

## Pending
- [ ] Wave 2 tasks not yet started
- [ ] Need to add rate limiting to login endpoint
- [ ] VERIFY phase not yet run
```

---

## Session Lifecycle

### 1. Starting a New Session

**Command:** `/do:start "description"`

What happens:
1. Creates `.work/` directory if it doesn't exist
2. Initializes `PROJECT.md` from your description
3. Initializes `STATE.md` with starting position
4. Creates `config.json` with defaults
5. Creates first phase directory
6. Begins the pipeline: Research -> Plan -> Build -> Verify

If `.work/` already exists, it reads STATE.md and continues from where you left off (same as `/do:resume`).

### 2. Pausing Work

**Command:** `/do:pause`

What happens:
1. Reads current STATE.md
2. Captures the exact current position:
   - Which phase
   - Which step (research, plan, build, verify)
   - Which wave/task if mid-build
   - Any in-flight decisions or context
3. Updates STATE.md with:
   - Status -> `paused`
   - Last Updated -> current timestamp
   - Last Action -> what was just completed
   - Next Action -> exactly what to do when resuming
   - Context -> decisions and state from this session
   - Pending -> incomplete items
4. Optionally commits `.work/` to git (if `git.commit_planning_docs` is true)
5. Confirms: "Work paused. Resume with `/do:resume`."

**You can also just close Claude Code.** The plugin updates STATE.md throughout execution, so even without an explicit pause, the state is recoverable. `/do:pause` just ensures a clean save point.

### 3. Resuming Work

**Command:** `/do:resume`

What happens:
1. Reads `.work/STATE.md` - determines current position
2. Reads `.work/PROJECT.md` - loads project context
3. Reads the current phase directory - loads phase-specific state
4. Displays to you:
   - Project name and description
   - Current phase and step
   - Last action taken
   - Next action planned
   - Any pending items
5. Asks: "Continue with: [next action]?"
6. On confirmation, executes the appropriate workflow step

**Resume routing:**

| STATE.md Next Action | Workflow Triggered |
| -------------------- | ------------------ |
| "Research phase XX" | Research workflow |
| "Plan phase XX" | Plan workflow |
| "Build phase XX" | Build workflow |
| "Execute Wave N" | Build workflow (mid-phase) |
| "Verify phase XX" | Verify workflow |
| "Fix CRITICAL issues" | Shows VERIFY.md, starts fixing |
| "Start next phase" | Creates next phase, starts Research |

### 4. Checking Status

**Command:** `/do:status`

What happens:
1. Reads STATE.md and PROJECT.md
2. Lists all phases with completion status
3. Shows current position
4. Shows next action
5. Lists any pending items

Output example:
```
Project: E-commerce Platform
Phase: 02-auth (step: build, status: in-progress)

Phases:
  [x] 01-database - complete
  [>] 02-auth - in progress (build, wave 2)
  [ ] 03-dashboard - pending
  [ ] 04-checkout - pending

Next: Execute Wave 2 (security hardening + session management)

Pending:
  - [ ] Add rate limiting to login endpoint
  - [ ] Run VERIFY phase
```

---

## State Updates During Execution

STATE.md is updated at every significant transition:

| Event | STATE.md Update |
| ----- | --------------- |
| Phase created | Phase set, step -> none, status -> initialized |
| Research starts | Step -> research, status -> in-progress |
| Research complete | Step -> research, status -> complete |
| Plan created | Step -> plan, status -> complete |
| Build starts | Step -> build, status -> in-progress |
| Wave N complete | Next Action updated to Wave N+1 |
| Build complete | Step -> build, status -> complete |
| Verify starts | Step -> verify, status -> in-progress |
| Verify complete | Step -> verify, status -> complete or needs-fixes |
| Phase complete | Status -> complete, next phase queued |
| Work paused | Status -> paused, full context saved |

---

## Multi-Phase Continuity

When a phase completes, the system:
1. Marks the phase as complete in STATE.md
2. Moves phase directory to `.work/archive/` (optional)
3. Creates the next phase directory
4. Updates STATE.md with the new phase
5. Asks: proceed to next phase?

Context from previous phases is preserved:
- Key decisions in STATE.md Context section
- Previous phase files remain readable
- PROJECT.md accumulates important decisions

---

## Git Integration

If `git.commit_planning_docs` is true in config.json:

| Event | Git Action |
| ----- | --------- |
| PROJECT.md created | `git add .work/PROJECT.md && git commit` |
| Phase research complete | `git add .work/phases/XX/ && git commit` |
| Phase plan complete | `git add .work/phases/XX/ && git commit` |
| Phase build complete | `git add .work/phases/XX/ && git commit` |
| Phase verify complete | `git add .work/phases/XX/ && git commit` |
| Work paused | `git add .work/ && git commit` |

Commit messages follow the format:
```
chore(do): <action> - phase XX <step>
```

---

## Failure Recovery

### If Claude Code crashes mid-session
STATE.md was last updated at the most recent transition. Resume with `/do:resume` - you may need to redo the last step.

### If a build task fails
BUILD.md logs the failure. On resume, the system presents options:
- Retry the failed task
- Skip it and continue
- Abort the phase

### If verification finds CRITICAL issues
VERIFY.md lists the findings. STATE.md Next Action is set to "Fix CRITICAL issues." On resume, the system shows the findings and starts fixing.

---

## Configuration

Session behavior is controlled by `.work/config.json`:

```json
{
  "mode": "interactive",     // "interactive" = confirm at each step
                              // "auto" = advance automatically
  "auto_advance": false,      // Auto-proceed to next phase on completion
  "git": {
    "commit_planning_docs": true  // Auto-commit .work/ changes
  }
}
```

### Interactive Mode (default)
- Pauses after Research to confirm
- Pauses after Plan to confirm
- Pauses after Build to show results
- Pauses after Verify to show findings
- You control the pace

### Auto Mode
- Advances through steps automatically
- Only stops on failures or CRITICAL findings
- Good for well-understood work where you trust the agents

Switch modes:
```
/do:settings mode auto
/do:settings mode interactive
```

---

## Tips

1. **Always check `/do:status` when starting a new Claude Code session** - it tells you exactly where you are.

2. **Use `/do:pause` before closing** if you want a clean save point with full context.

3. **STATE.md is human-readable** - you can edit it directly if the system gets confused about where you are.

4. **PROJECT.md accumulates decisions** - review it periodically to make sure it reflects reality.

5. **Phase directories are self-contained** - each phase has its own RESEARCH, PLAN, BUILD, VERIFY files. You can review any phase independently.
