<purpose>
"Just do it" - zero ceremony execution. For well-understood tasks where you know what you want.
Skips brainstorming. Brief research. Single-wave plan. Fast verify. Only stops for CRITICAL findings.
The user already said "go" — don't ask again.
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

Show the plan as a brief summary in output. Do NOT ask for approval. Proceed immediately.

## 5. Build (Single Wave)

1. Resolve models from config.json
2. Dispatch all task agents in parallel (respecting max_concurrent)
3. Compile results into `BUILD.md`

After build, if code was modified and git is configured:
- Auto-commit using conventional commit format derived from the goal
- Report the commit message and affected files in output
- Do NOT ask for permission

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
- The only allowed stop is CRITICAL findings (step 6). Everything else: just do it.
- Plan is shown, not approved.
- Commits are automatic, not confirmed.
- If the task fails, fall back to full /do:start for a more structured approach.
</guidelines>
