# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **UX always wins principle**: Workflows (research, plan, brainstorm) now silently pick the higher-UX option when the only tradeoff is "easier to build" vs "better UX" — no more asking the user to choose between UX tiers.
- **Discovery cache**: `/do:discover` now skips regeneration when `.work/context/` is fresh (< 30 days, < 50 commits since last run). Cache metadata written to `.work/context/.cache-meta.json`. Pass `--force` to regenerate.
- **Cost-aware wave gating**: `start.md` and `go.md` now skip Design / Docs / Verify waves based on PLAN.md complexity classification. Trivial tasks run coder only; simple tasks run coder + reviewer. Enforced, not advisory.

### Changed
- **Model profile — `balanced`**: `do-reviewer`, `do-qa`, `do-researcher`, `do-docs`, and `do-devops` downshifted from Sonnet to Haiku 4.5 (~3× cheaper, ~90% quality on pattern-matching work). Override via `model_overrides` for projects needing higher rigor.
- **Agent dispatch**: Build prompts now instruct agents to prefer cached `.work/context/` files over Glob/Grep'ing the whole repo, eliminating redundant codebase rediscovery on every wave.

## [1.0.0] - 2026-04-04

### Added

- feat!: apply best principles to everything (b97c56a)
## [1.1.0] - 2026-04-04

### Added
- KISS/Kodawari/DRY/SOLID quality principles in all 26 agent definitions
- Mandatory verification loop in do-coder (build -> test -> security -> perf -> fix -> repeat)
- Quality verification loop in build workflow (security + perf + code review audit after every build, up to 3 iterations)
- Enterprise/production-readiness requirements for all engineering agents
- Domain-specific quality standards per agent (zero-trust for security, chaos-ready for reliability, measure-first for perf, contract-first for integrator, zero-downtime for migrator)
- Professional standards for all business/people/product agents

## [1.0.0] - 2026-04-04

### Breaking Changes
- Command surface consolidated from 18 to 8 commands: start, it, brainstorm, debug, review, status, settings, help
- Removed standalone commands: /do:pause, /do:save, /do:resume, /do:discover, /do:setup, /do:plan, /do:build, /do:verify, /do:research
- /do:start now handles initialization, codebase discovery, setup, and resume
- /do:status now includes navigation and resume capabilities

### Added
- Apple UX philosophy: recommendation-led, minimal, no dead ends
- Every AskUserQuestion has a recommended option marked first
- All freeform questions replaced with structured single-select options
- Brainstorm flows directly into start pipeline (no manual command needed)
- First-run experience: 2-3 focused questions, then work begins
- Returning user experience: auto-detected context and navigation
- Transparency: every automated action announced with status line
- Iterative single-select pattern replaces all "select all that apply" flows
- "Show details" in verify and debug re-presents options after showing context

### Changed
- Settings flattened to 2 levels max (was 3 for model_overrides)
- Verify: "Fix all remaining" removed; each finding is its own decision
- Templates synced with workflows (Complexity, Decisions, timestamp fields added)
- Help shows 8-command surface with current project state
- Status absorbs resume: select "Continue" to pick up where you left off

## [0.5.0] - 2026-03-28

### Added
- Documentation agent (do-docs) for automatic README/CHANGELOG updates after every build

## [0.4.0] - 2026-03-25

### Changed
- Spec-driven workflow improvements

## [0.3.0] - 2026-03-19

### Added
- Kodawari and KISS design principles

### Changed
- Smarter agent selection based on task classification
- Decreased context usage for main orchestrator window
- Granular adjustments to agent dispatch rules

## [0.2.0] - 2026-03-13

### Added
- 5 new commands: /do:it, /do:debug, /do:research, /do:help, /do:pause
- Overhauled discovery workflow with 6 parallel agents

### Fixed
- Permission errors failing silently in subagents
- Agents unable to call other agents

### Changed
- Settings-driven workflows with mandatory agent dispatch rules

## [0.1.0] - 2026-03-11

### Added
- Initial release with 25 specialist agents across 5 departments
- Full execution pipeline: research -> plan -> build -> verify
- Brainstorm, start, discover, setup, plan, build, verify commands
- Review, status, resume, save, settings commands
- Context layering system (base + project + department + agent-specific)
- Model profiles: quality, balanced, budget
- Fast mode for reduced ceremony
- Git workflow with conventional commits
- Session continuity via STATE.md
- Install and uninstall scripts
