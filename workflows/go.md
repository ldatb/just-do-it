<purpose>
Zero-ceremony execution. Same pipeline as start.md but: fast_mode forced on, no decision
prompts, no plan approval, single wave. Only stops for CRITICAL findings.
</purpose>

<process>

## 1. Initialize

**No `.work/`:** Create `.work/` with: PROJECT.md (from $ARGUMENTS), STATE.md, config.json (defaults: fast_mode=true, balanced profile, commits only), capabilities.md, context/
If existing code: quick single-agent discovery (stack + structure only). If greenfield: skip.

**`.work/` exists:** Read state and config. Force fast_mode on for this execution.

## 2. Phase

Create `.work/phases/XX-<name>/` from $ARGUMENTS. No prompt.

## 3. Classify Complexity

Classify $ARGUMENTS per `references/intelligence.md` § Cost-Aware Routing:
- **trivial**: single file, <50 lines changed, no risk surface
- **simple**: 1-3 files, single concern, no architecture decisions
- **standard / complex**: multi-file, architecture, or any risk surface (auth/data/money/external systems)

Any risk surface = at least **standard**. Note the classification — it gates every wave below.

## 4. Research

**Skip entirely if trivial or simple.** Go straight to Plan.

Otherwise dispatch one `do-researcher`: "Top 2-3 things to know before implementing: $ARGUMENTS."
Write brief RESEARCH.md. Do NOT ask user to review. Proceed immediately.

## 5. Plan

Create single-wave PLAN.md: goal (one sentence), **complexity classification**, tasks (minimal list), agent per task.
Show brief summary in output. Do NOT ask for approval. Proceed immediately.

## 6. Build

If `git.use_branches` is true:
- Print: "Creating branch feat/<phase-name>..."
- Create the branch.

**Respect complexity:**
- **trivial**: dispatch `do-coder` only.
- **simple / standard / complex**: dispatch task agents per PLAN.md in parallel (respecting max_concurrent).

Compile BUILD.md.

If code modified:
- If `git.auto_commit` is true: print `Auto-committing: <type>: <description> (<N> files)...` then auto-commit with conventional message.
- If `git.auto_commit` is false: ask user before committing.

## 7. Documentation Update

**Respect complexity:**
- **trivial**: skip. Announce: `Skipping Docs (complexity: trivial).`
- **simple**: skip unless README/public API/user-facing surface was touched.
- **standard / complex**: always dispatch `do-docs` with phase PLAN.md, BUILD.md, and modified file list.

Print: `Dispatching do-docs to update project documentation.` (when running)

## 8. Verify

**Respect complexity:**
- **trivial**: skip entirely. Announce: `Skipping Verify (complexity: trivial).` Run `make test` / `npm test` / language-appropriate test command via Bash as a sanity check if one is obvious.
- **simple**: dispatch `do-reviewer` only.
- **standard / complex**: dispatch `do-qa` + `do-reviewer` only (fast mode).

Run the auto-fix loop from `workflows/verify.md` §6 (CRITICAL + HIGH auto-fix, capped iterations, no per-finding prompts). Use `verify.auto_fix` from config.

If loop exhausts with blockers remaining: surface single summary prompt per `verify.md` §6. Otherwise: done.

## 9. Done

Update STATE.md. Print: "Done: [what was built]. [N files modified]."

</process>

<rules>
Speed over ceremony. Every prompt that can be skipped, skip it.
Every automated action gets a status line before it happens.
If the task fails, suggest `/do:start` for a more structured approach.
</rules>
