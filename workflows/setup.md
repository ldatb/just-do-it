<purpose>
Interactive setup for a new or existing project. Gather information from the user
to generate project-specific context files that customize agent behavior.
</purpose>

<process>

## 1. Pre-flight

Check if `.work/` exists. If not, create it with default config.
Create `.work/context/` directory.

## 2. Project Basics

Ask the user:

**"What are you building?"**
- Project name
- One-sentence description
- Core value / the ONE thing that must work

**"What's the current state?"**
- Greenfield (starting from scratch)
- Brownfield (existing codebase) - suggest `/do:discover` for automatic analysis
- Non-code (business, marketing, ops, etc.)

## 3. Domain-Specific Questions

Based on the project type, ask targeted questions:

### If Engineering Project:
- Tech stack (language, framework, database)
- Architecture (monolith, microservices, serverless)
- Deployment target (cloud provider, platform)
- Auth approach (if applicable)
- Existing conventions or style guide
- Testing framework preference
- CI/CD setup (or desired)

### If Business Project:
- Industry and market
- Target audience
- Key competitors
- Current stage (idea, MVP, growth, mature)
- Team size and structure
- Existing tools and processes

### If Mixed (code + business):
Ask both sets, keeping it concise.

## 4. Constraints & Preferences

Ask:
- **Timeline:** Any deadlines?
- **Budget:** Cost sensitivity for model profiles?
- **Quality bar:** What's the standard? (startup-speed vs enterprise-grade)
- **Preferences:** Anything specific about how you like to work?

## 5. Generate Context Files

From the answers, generate:

### .work/context/project.md
- Project name, description, core value
- Tech stack (if applicable)
- Target audience
- Key constraints
- Quality bar

### .work/context/engineering.md (if engineering project)
- Stack details and versions
- Architecture decisions
- Conventions to follow
- Testing approach
- Deploy target

### .work/context/business.md (if business project)
- Industry context
- Competitive landscape
- Target audience profile
- Current stage and goals

### Department/agent-specific files as warranted by the answers.

## 6. Generate PROJECT.md

Create `.work/PROJECT.md` from the setup answers:
- What This Is
- Core Value
- Requirements (initial, from discussion)
- Constraints
- Key Decisions

## 7. Configure Settings

Based on answers, suggest config.json adjustments as individual options:

Use AskUserQuestion:
- header: "Setup: Config"
- question: "Suggested settings based on your answers: (select all that apply)"
- options: one per suggestion, each showing the setting and why. Examples:
  - "model_profile: balanced → quality" - enterprise-grade quality bar
  - "model_overrides.security: → opus" - auth-heavy project
  - "fast_mode: false → true" - prototype/MVP pace
  - "Done" - apply selected and continue

## 8. Present Summary

Show what was generated:
- List each context file with a one-line description
- PROJECT.md highlights

Use AskUserQuestion:
- header: "Setup Complete"
- question: "Files generated. What to review?"
- options: one per generated file, plus:
  - "Review project.md" - check project overview
  - "Review engineering.md" - check engineering context (if generated)
  - "Review business.md" - check business context (if generated)
  - "Review config.json" - check settings
  - "Looks good, proceed" - accept and move on

## 9. Update State

Update STATE.md:
- Status: setup-complete
- Last Action: Project setup complete
- Next Action: Ready - use `/do:start` to begin

</process>
