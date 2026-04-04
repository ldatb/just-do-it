<purpose>
Standalone research on a topic, technology, or approach. Dispatches do-researcher agents,
presents findings with tradeoffs, asks the user about key decisions, and produces RESEARCH.md.
Can run independently or feed into the plan phase.
</purpose>

<process>

## 1. Initialize

1. Read `.work/config.json` if it exists (for model profile and fast_mode)
2. Read `.work/context/project.md` if it exists (for project context)
3. Determine output location:
   - If a current phase exists in STATE.md: write to that phase directory
   - Otherwise: write to `.work/` root

## 2. Dispatch Researchers

**Use the Agent tool** to dispatch `do-researcher` agents. You do NOT research yourself.

Resolve model for `do-researcher` from config.

Infer research angle from $ARGUMENTS:
- If comparing options: focus on alternatives and trade-offs
- If exploring a technology: focus on prior art and best practices
- If assessing risk: focus on pitfalls and failure modes
- If unclear: cover all angles

**If fast mode:** Single agent, focused on top 2-3 findings.

**If normal mode:** Up to 3 agents in parallel, each covering a different angle:
- Agent 1: Libraries, packages, existing solutions
- Agent 2: Architecture approaches, patterns, best practices
- Agent 3: Risks, pitfalls, trade-offs

Each agent reads project context files before researching.

## 3. Compile Findings

Compile all agent outputs into `RESEARCH.md`:

```markdown
# Research: [Topic]

## Objective
[What we needed to learn]

## Key Findings
[Top 3-5 findings, prioritized]

## Options Comparison (if applicable)
| Option | Pros | Cons | Recommendation |
|--------|------|------|----------------|
| ... | ... | ... | ... |

## Prior Art
[Existing solutions found]

## Risks
[What could go wrong]

## Recommendation
[Clear next step with rationale]

## Decisions
[Filled in after user input in step 4]
```

## 4. Present Findings and Ask for Decisions (MANDATORY)

**You MUST present research findings to the user and ask about key decisions. Do NOT silently
write RESEARCH.md and move on.**

After compiling findings, analyze them and identify:

1. **Decisions that need user input** — which library, which approach, which pattern
2. **Tradeoffs the user should understand** — "A is faster but B is more flexible"
3. **Things the user hasn't thought about** — risks, hidden dependencies, constraints, edge cases

**Think ahead of the user.** Surface decisions they don't know they need to make. Examples:
- "This requires choosing between X and Y — X is simpler but Y scales better"
- "The library you mentioned is deprecated. Here are 3 alternatives."
- "This approach will also require Z, which isn't in scope yet — add it now or defer?"
- "There's a compatibility issue between A and B that will affect your choice"

### Format:

1. **Print a research summary** (3-5 bullets with key findings and tradeoffs)

2. **For each decision point**, use a SEPARATE AskUserQuestion:
   - header: "Research: [Decision Topic]"
   - question: "[Clear question explaining why this matters and your recommendation]"
   - options: [2-4 concrete options, first option marked (Recommended), each with a brief tradeoff note]

   Present each decision individually — never bundle multiple decisions into one prompt.

3. **Give your recommendation** with each question — don't just list options neutrally.
   The first option must always be the recommended one, marked with `(Recommended)`.

### Rules:
- Keep decision questions to 2-4 max per research session
- Don't ask about things config already answers
- Only ask about decisions that genuinely affect the outcome
- Always mark the first option with (Recommended)
- After getting answers, save decisions to RESEARCH.md under `## Decisions`

## 5. Update State

If `.work/STATE.md` exists, update:
- Last Action: "Research: [topic]"
- Next Action: ready for planning or next task

</process>
