<purpose>
Zero-ceremony execution. Same pipeline as start.md but: fast_mode forced on, no decision
prompts, no plan approval, single wave. Only stops for CRITICAL findings.
</purpose>

<process>

## 1. Initialize

**No `.work/`:** Create it with defaults: fast_mode=true, balanced profile, commits only.
If existing code: quick single-agent discovery (stack + structure only). If greenfield: skip.

**`.work/` exists:** Read state and config. Force fast_mode on for this execution.

## 2. Phase

Create `.work/phases/XX-<name>/` from $ARGUMENTS. No prompt.

## 3. Research

Dispatch one `do-researcher`: "Top 2-3 things to know before implementing: $ARGUMENTS."
Write brief RESEARCH.md. Do NOT ask user to review. Proceed immediately.

## 4. Plan

Create single-wave PLAN.md: goal (one sentence), tasks (minimal list), agent per task.
Show brief summary in output. Do NOT ask for approval. Proceed immediately.

## 5. Build

Dispatch all task agents in parallel (respecting max_concurrent). Compile BUILD.md.
If code modified and git configured: auto-commit with conventional message. No prompt.

## 6. Documentation Update (MANDATORY)

Dispatch `do-docs` with phase PLAN.md, BUILD.md, and modified file list.
Never skipped, even in fast/go mode.

## 7. Verify

Dispatch `do-qa` + `do-reviewer` only.
If CRITICAL: ask fix now or skip. Otherwise: done.

## 8. Done

Update STATE.md. Print: "Done: [what was built]. [N files modified]."

</process>

<rules>
Speed over ceremony. Every prompt that can be skipped, skip it.
If the task fails, suggest `/do:start` for a more structured approach.
</rules>
