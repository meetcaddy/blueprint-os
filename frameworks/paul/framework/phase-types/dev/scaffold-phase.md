---
schema_version: 1.0
name: scaffold-phase
display_name: Project Scaffold Phase
category: dev
purpose: Initial project structure setup. Picks the right Claude Code component shape (agent, command, skill, hook, rule) and generates ready-to-use scaffolding.
duration: short
risk_level: low
triggers:
  keywords: [scaffold, bootstrap, new project, initial setup, project structure, starter, boilerplate]
  patterns: ['new\s+(project|app|service|tool)', 'set\s+up\s+(a|the)\s+\w+', 'starting\s+from\s+scratch']
  file_signals: []
  required_after: []
  required_before: [spec-phase, plan-phase]
  recommended_for: [greenfield projects, brand-new builds, projects with no existing structure]
recommended_skills: [skillsmith]
related_paul_workflows: [paul:init, paul:milestone]
sources: [cc-ultimate-guide examples/commands/scaffold.md]
---

# Project Scaffold Phase

## Purpose

Set up a new project's foundational structure. For Claude Code component projects: identifies whether the user needs an agent, command, skill, hook, or rule, then generates the right scaffolding. For non-component projects: picks the right starter structure (folders, config files, README, gitignore).

## When to recommend

- User explicitly says they're starting a new project / building from scratch
- No existing project structure detected (empty directory, brand-new repo)
- User asks "how do I structure this?" or "what should I build first?"
- Greenfield work where no PROJECT.md / ROADMAP.md exists yet

## Phase template (becomes the roadmap phase scope when accepted)

### Goal
Establish a working project skeleton: file structure, config files, version control, initial documentation. Customer can begin substantive work after this phase completes.

### Scope
- Identify project type (Claude Code component, web app, CLI tool, etc.)
- Run interactive coaching to pick the right structure
- Generate scaffolding files (folders, configs, README, .gitignore)
- Set up version control (git init + .gitignore)
- Verify scaffolding by running any "hello world" the structure provides

### Plans (suggested decomposition)
- [ ] Plan 1: Discovery, interactive Q&A to identify project shape (5 questions max)
- [ ] Plan 2: Generate scaffolding, write the folder tree and config files
- [ ] Plan 3: Initialize version control + first commit
- [ ] Plan 4: Verify scaffolding works (run init script, smoke test)

### Dependencies
None. This is typically the first phase of a new project.

### Verification
- Folder structure exists as planned
- Config files validate (package.json parses, pyproject.toml parses, etc.)
- `git status` shows clean tree after first commit
- Hello-world or smoke test runs without error

## Skills orchestrated

1. `skillsmith`, for Claude Code component projects, generates skill/command/hook/rule templates
2. `frontend-design`, for web projects, sets up frontend scaffold

## Source notes

**Primary source:** cc-ultimate-guide `examples/commands/scaffold.md`, interactive coach with 5 questions (trigger, domain expertise, complexity, reuse scope, output type) leading to a decision tree. Covers Claude Code component scaffolding (agent vs command vs skill vs hook vs rule).

**Adapted for Caddy:** the original scaffold.md is Claude-Code-component-specific. Caddy's scaffold-phase generalizes to ANY new project, Claude Code components are one branch of the decision tree. The 5-question discovery flow is preserved as a sub-step.

**Not merged from any other source.** No GSD equivalent.

## Anti-patterns

- DO NOT use this phase for refactoring an existing project. That's a different phase type (refactor-phase, deferred to v3.5).
- DO NOT use this phase to "redesign" an in-progress project. Use `/paul:milestone` to start a new milestone instead.
- DO NOT skip the discovery questions. The 5-question Q&A determines what gets scaffolded; skipping leads to wrong shape.
