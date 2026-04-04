<purpose>
Internal workflow — invoked by start.md for greenfield projects. The /do:setup command has been removed.

Greenfield project setup. Gather structured context from the user to generate project-specific
context files that customize agent behavior. Maximum 4 questions total - no freeform prose.
Triggered automatically by start.md on first run when no existing codebase is detected.
</purpose>

<process>

## 1. Pre-flight

Check if `.work/` exists. If not, create it with default config.
Create `.work/context/` directory.
Auto-detect whether code exists in the current directory (beyond `.git` and dotfiles).
If code exists, this is a brownfield project - use discover workflow instead. Setup is for greenfield only.

## 2. Project Type

Use AskUserQuestion:
- header: "Setup: Project Type"
- question: "What kind of project is this?"
- options:
  - "Engineering - building software (Recommended)" - code, APIs, infrastructure
  - "Business - strategy, marketing, operations" - planning, content, process
  - "Mixed - code plus business context" - product and engineering combined

## 3. Tech Stack (only if engineering or mixed)

Use AskUserQuestion:
- header: "Setup: Stack"
- question: "What's the primary tech stack?"
- options:
  - "I'll describe it in the task (Recommended)" - no preset; agents infer from your description
  - "Node.js / TypeScript" - JavaScript ecosystem
  - "Python" - Python ecosystem
  - "Go" - Go ecosystem

## 4. Quality Bar

Use AskUserQuestion:
- header: "Setup: Quality"
- question: "What quality bar should agents target?"
- options:
  - "Production-ready (Recommended)" - thorough testing, security checks, proper error handling
  - "MVP / prototype" - fast iteration, lower ceremony, skip exhaustive verification
  - "Exploratory" - spike or experiment; output is throwaway code

## 5. Generate Context Files

From the answers, generate:

### .work/context/project.md
- Project name and description (from $ARGUMENTS or inferred)
- Project type
- Quality bar
- Key constraints

### .work/context/engineering.md (if engineering or mixed)
- Stack details from answers
- Quality and testing expectations
- Conventions to follow (defaults until discovery reveals specifics)

### .work/context/business.md (if business or mixed)
- Industry context (if provided)
- Project goals
- Target audience (if known)

Print: `Generating context files from setup answers...`

## 6. Generate PROJECT.md

Create `.work/PROJECT.md`:
- What This Is
- Core Value (inferred from $ARGUMENTS)
- Constraints (from quality bar and stack choices)
- Key Decisions (from setup answers)

## 7. Config Suggestions

Based on answers, determine suggested config.json adjustments.

Present using an iterative single-select loop. Do NOT ask the user to "select all that apply."

Use AskUserQuestion:
- header: "Config: Recommendations"
- question: "Setup found <N> recommended settings. Apply one, or select Done when finished."
- options:
  - "<setting>: <current> -> <recommended> (Recommended)" - <one-sentence rationale>
  - "<setting>: <current> -> <recommended>" - <one-sentence rationale>
  - "Done" - proceed without further changes

After each selection (except "Done"): apply the change to config.json immediately, print the updated value, then re-present the menu with that option removed.

If no suggestions exist, skip this step.

## 8. Present Summary

Show what was generated:
- List each context file with a one-line description
- PROJECT.md highlights

Use AskUserQuestion:
- header: "Setup Complete"
- question: "<N> context files generated. What would you like to review?"
- options:
  - "Looks good, proceed (Recommended)" - accept and move on to pipeline
  - "Review project.md" - check project overview
  - "Review engineering.md" - check engineering context (if generated)
  - "Review business.md" - check business context (if generated)

When user selects a review option: display the requested file, then re-present the identical AskUserQuestion.

## 9. Update State

Update STATE.md:
- Status: setup-complete
- Last Action: Project setup complete
- Next Action: Ready for pipeline

</process>
