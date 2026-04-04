<purpose>
Interactive brainstorming session - explore ideas, identify requirements, consider alternatives,
and refine scope before committing to the full pipeline.

This runs BEFORE research/plan/build/verify. The output is a clear description ready for the
start pipeline, which is triggered directly when the user is ready - no manual command needed.

The brainstorm should feel like talking to a smart colleague - conversational but structured.
</purpose>

<process>

## 1. Open the Conversation

**If $ARGUMENTS is provided:**
Acknowledge the topic. Summarize your initial understanding of what the user wants to explore. Then jump straight to the exploration loop (step 2).

**If $ARGUMENTS is empty:**

Use AskUserQuestion:
- header: "Brainstorm"
- question: "What are you thinking about building or working on? Can be vague - we'll refine it together."
- options:
  - "Let me describe it (Recommended)" - I'll type a description of what I want to build
  - "I have a problem to solve" - start from the problem, not the solution
  - "I want to explore a technology" - start from a tool, framework, or pattern
  - "I have a rough idea" - half-formed thought to flesh out

Based on the user's response, form an initial understanding and proceed to the exploration loop.

## 2. Exploration Loop

This is the core of the brainstorm. Iterate through rounds of conversation. Each round:

1. **Reflect** - Summarize your current understanding of the idea in 2-3 sentences. Be specific about what you think the user wants. This lets them correct misunderstandings early.

2. **Ask one clarifying question** - Pick the most important unknown. Ask one question at a time, not a list. Good questions:
   - "Who is this for?" (audience/users)
   - "What does success look like?" (goals/metrics)
   - "What's the simplest version that would be useful?" (MVP scope)
   - "What's the biggest risk or unknown?" (constraints)
   - "Is there something similar you've seen that you like?" (prior art)
   - "What should this NOT do?" (anti-requirements)
   - "What's your timeline?" (urgency)
   - "What tech constraints exist?" (stack/infra)

3. **Offer options** - Always end with selectable choices. Maximum 4 authored options.

Use AskUserQuestion:
- header: "Brainstorm"
- question: "[Your clarifying question]"
- options:
  - "[Specific answer A] (Recommended)" - brief context based on what you'd suggest
  - "[Specific answer B]" - brief context
  - "[Specific answer C]" - brief context
  - "Something else" - I'll describe a different direction

The specific answer options should be contextual - real suggestions based on the conversation so far. Do not use generic placeholders. Think about what a knowledgeable colleague would suggest. Mark the answer you would recommend first with (Recommended).

**Guidelines for the exploration loop:**
- Keep each round short. One question, one reflection, options.
- Suggest concrete approaches when you have enough context. Be opinionated but open.
- Push back gently if scope is too large. Suggest phasing.
- Mention trade-offs when relevant (build vs buy, simple vs flexible, fast vs thorough).
- If the user keeps exploring without narrowing, after 5-6 rounds, nudge toward scoping.
- Use web search or web fetch if the user wants to explore specific technologies or prior art.
- If the conversation reveals this is a well-known problem pattern, say so and suggest proven solutions.

## 3. Suggest Approaches

When you have enough context (typically after 3-5 rounds), proactively suggest an approach:

Present a brief proposal:
- **What:** one-sentence description
- **How:** key technical/strategic choices (2-3 bullets)
- **Scope:** what's in v1, what's deferred
- **Risks:** top 1-2 concerns

Use AskUserQuestion:
- header: "Proposed Approach"
- question: "Here's what I'd suggest. Thoughts?"
- options:
  - "Looks good - let's go with this (Recommended)" - proceed to save and start
  - "Modify the approach" - adjust specific aspects
  - "Too big - simplify" - reduce scope before starting
  - "Different direction entirely" - pivot and keep exploring

If the user modifies, loop back to step 2 with the refined understanding.

## 4. Save Brainstorm Summary

When the user chooses to save or is ready to start:

1. Ensure `.work/` exists. If not, note that `/do:start` will create it.

2. Determine the phase name from the brainstorm topic. Use a short, descriptive slug (e.g., `oauth-login`, `dashboard-mvp`, `q1-marketing-plan`).

3. Create the phase directory if it does not exist:
   ```
   .work/phases/XX-<name>/
   ```
   Use the next available phase number (check existing phases).

4. Write `BRAINSTORM.md` to the phase directory with this structure:

   ```markdown
   # Brainstorm Summary

   ## Idea
   [One-paragraph description of what the user wants to build/do]

   ## Context
   - Who: [target users/audience]
   - Why: [motivation/problem being solved]
   - Timeline: [urgency/deadline if mentioned]
   - Constraints: [tech stack, budget, existing systems, etc.]

   ## Requirements
   - [Requirement 1]
   - [Requirement 2]
   - [...]

   ## Deferred / Out of Scope
   - [Item 1]
   - [Item 2]

   ## Approach
   [Summary of the agreed approach, key decisions made]

   ## Open Questions
   - [Anything unresolved that research should address]

   ## Alternatives Considered
   - [Alternative 1] - [why rejected/deferred]
   - [Alternative 2] - [why rejected/deferred]
   ```

   Only include sections that have content. Skip empty sections.

5. Show the user the saved summary.

## 5. Hand Off

After saving:

Use AskUserQuestion:
- header: "Brainstorm Complete"
- question: "Brainstorm saved to .work/phases/XX-<name>/BRAINSTORM.md. What next?"
- options:
  - "Start building now (Recommended)" - invoke start pipeline with the refined description
  - "Keep brainstorming" - return to exploration; refine scope or explore alternatives
  - "Done for now" - save and stop; return with /do:start when ready

If the user chooses "Start building now":
1. Compose the refined description from the brainstorm summary (one sentence capturing agreed scope).
2. Print: "Starting pipeline with: <refined description>"
3. Invoke the start workflow directly, passing the refined description as $ARGUMENTS.
   Do NOT tell the user to type a command. Execute immediately.

If the user chooses "Keep brainstorming":
- Return to the exploration loop (step 2) with the current understanding intact.

If the user chooses "Done for now":
- Confirm the save path and stop. The user can run /do:start when ready.

</process>

<guidelines>
- One question at a time. Never dump a list of questions.
- Be opinionated. Suggest things. A good brainstorm partner has ideas, not just questions.
- Keep it conversational. Short paragraphs, direct language.
- Push toward specificity. Vague ideas become concrete plans.
- Respect the user's expertise. They know their domain - you help structure their thinking.
- Do not research or plan during brainstorm. That comes later in the pipeline.
- The brainstorm can be short (2-3 rounds) or long (10+ rounds). Follow the user's lead.
- If the user already knows exactly what they want, skip to step 3 quickly.
- Maximum 4 options per AskUserQuestion. Mark the recommended choice first.
</guidelines>

<warning>
This is a brainstorming session, not a planning session. Do not:
- Create detailed implementation plans (that's the plan phase)
- Write code or pseudocode (that's the build phase)
- Research libraries or tools in depth (that's the research phase)
- Create file structures or architecture diagrams (that's the plan phase)

Keep it high-level. The output is a clear description and requirements, not a blueprint.
</warning>
