# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.4.0] - 2026-03-25

### Maintenance

- chore: update CHANGELOG.md for v0.3.0 (e74dd53)
## [0.3.0] - 2026-03-19

### Added

- feat: use kodawari and KISS (0c02d2f)

### Documentation

- docs: github repo link (7bad922)

### Maintenance

- chore: granular adjustments (646c9dc)
- chore: smarter agent selection (49d39c3)
- chore: decrease context usage for main window (21342c0)
- chore: update CHANGELOG.md for v0.2.0 (38f10af)
## [0.2.0] - 2026-03-13

### Added

- feat: add 5 new commands, overhaul discovery, fix agent bugs (04fc35a)

### Fixed

- fix: permission errors failing silently (761433f)
- fix: agents not calling other agents (7f1eccd)

### Changed

- refactor: settings-driven workflows, mandatory agent dispatch rules (728cbc1)
## [0.1.0] - 2026-03-11

### Added

- 25 specialist agents across 5 departments:
  - Engineering (11): coder, architect, security, reliability, qa, devops, debugger, perf, integrator, migrator, data
  - Business (5): strategist, marketer, sales, finance, ops
  - People and Legal (4): hr, legal, compliance, support
  - Product and Design (2): product, designer
  - Cross-Cutting (3): researcher, reviewer, writer
- Full execution pipeline: research -> plan -> build -> verify
- `/do:brainstorm` command for interactive idea exploration before starting
- `/do:start` command for full pipeline execution
- `/do:discover` command to scan existing codebases and generate agent context
- `/do:setup` command for interactive project setup (greenfield)
- `/do:plan`, `/do:build`, `/do:verify` for individual phase control
- `/do:review` for multi-specialist code review
- `/do:status`, `/do:resume`, `/do:save` for session management
- `/do:settings` for configuration (model profiles, fast mode, git, agents)
- Context layering system: base agent + project.md + department.md + agent-specific.md
- Model profiles: quality (opus), balanced (sonnet), budget (haiku)
- Per-agent model overrides in `.work/config.json`
- Fast mode for reduced ceremony on well-understood work
- Git workflow with conventional commits (branches and messages)
- All git operations require explicit user approval
- Session continuity via `.work/STATE.md`
- Install and uninstall scripts
- Full documentation in `docs/`
