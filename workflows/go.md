<purpose>
"Just do it" - minimal ceremony execution. For well-understood tasks where you know what you want.
Skips brainstorming. Brief research. Single-wave plan. Fast verify. Only stops for git and CRITICAL findings.
</purpose>

<process>

## 1. Quick Initialize

**If `.work/` does not exist:**
1. Create `.work/` directory, config.json, STATE.md, PROJECT.md
2. Set `fast_mode: true` in config.json
3. Skip setup prompts - use defaults: balanced profile, commits only, fast mode
4. If existing code: run a single quick discovery agent (stack + structure only)
5. If greenfield: skip discovery, proceed directly

**If `.work/` exists:**
1. Read STATE.md and config.json
2. Temporarily enable fast_mode if not already on

## 2. Create Phase

Create `.work/phases/XX-<name>/` using next available number.
Derive phase name from $ARGUMENTS (short kebab-case slug).

No confirmation prompt. Just create it.

## 3. Quick Research (30 seconds max)

Dispatch a single `do-researcher` agent with a focused prompt:
- "What are the top 2-3 things I need to know before implementing: $ARGUMENTS"
- Keep it brief. No deep dives.

Write findings to phase `RESEARCH.md` (brief format).

Do NOT ask the user to review research. Proceed immediately.

## 4. Minimal Plan

Create a single-wave `PLAN.md`:
- Goal: one sentence from $ARGUMENTS
- Tasks: minimal list, all in one wave
- Each task: agent + what to do

Show the plan briefly to the user.

Use AskUserQuestion:
- header: "Quick Plan"
- question: "Plan for: [goal]. Build it?"
- options:
  - "Yes, go" - execute immediately
  - "Adjust" - modify before building
  - "Stop" - save and exit

## 5. Build (Single Wave)

1. Resolve models from config.json
2. Dispatch all task agents in parallel (respecting max_concurrent)
3. Compile results into `BUILD.md`

After build, if code was modified and git is configured:

Use AskUserQuestion:
- header: "Commit"
- question: "Done. Commit changes? [show files + proposed message]"
- options:
  - "Yes, commit" - commit with proposed message
  - "Edit message" - modify commit message
  - "Skip" - don't commit

## 6. Quick Verify

Dispatch only `do-qa` + `do-reviewer` (2 agents, parallel).

**If CRITICAL findings:**
Use AskUserQuestion:
- header: "Critical Issues"
- question: "Found critical issues. Fix now?"
- options:
  - "Fix now" - address immediately
  - "Skip" - ignore and finish

**If PASS or no CRITICAL:**
Report done. Update STATE.md. No prompt needed.

## 7. Done

Update STATE.md:
- Phase: complete
- Last Action: "go" execution complete
- Next Action: ready for next task

Show a one-line summary: "Done: [what was built]. [N files modified]."

</process>

<guidelines>
- Speed over ceremony. Every prompt that can be skipped, skip it.
- One-wave only. No multi-wave plans.
- Brief output. No verbose logs.
- Git approval is the only mandatory stop (plus CRITICAL findings).
- If the task fails, fall back to full /do:start for a more structured approach.
</guidelines>
