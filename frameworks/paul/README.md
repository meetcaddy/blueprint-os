# PAUL

> **Caddy customer-disk framework.** This repository ships PAUL as part of the Caddy operator-rhythm experience. Customers install via the Caddy Homebrew tap (macOS) or Scoop bucket (Windows); see "Installation" below.

PAUL is a structured planning + execution framework with PLAN/AUDIT/APPLY/UNIFY loops. It helps customers turn ambitious goals into discrete, testable plans, then executes them with built-in checkpoints + accountability.

## Ownership

Owned and maintained by Orbital Access LLC d/b/a Meet Caddy.

Customer-facing brand: Caddy. Your unfair advantage.
Support: hi@meetcaddy.com

## Version

**v0.2.0** (adds the 12 specialist subagents; see VERSION-NOTES.md)

Future updates ship as new tagged releases. Customers receive them via `brew upgrade caddy-paul` (Mac) or `scoop update caddy-paul` (Windows). The Caddy Homebrew tap and Scoop bucket pin to specific tags here.

## Installation

> **For Caddy customers only.** This is a private repository; access is granted via GitHub collaborator add as part of your Caddy onboarding. Installation flows through the Caddy Homebrew tap or Scoop bucket; you do not need to clone this repo directly.

**macOS (via Homebrew):**

```sh
brew tap meetcaddy/caddy
brew install caddy-paul
```

The formula clones this private repo via your GitHub credentials and installs files into `~/.claude/`. Future updates: `brew upgrade caddy-paul`.

**Windows (via Scoop):**

```sh
scoop bucket add caddy https://github.com/meetcaddy/scoop-caddy
scoop install caddy-paul
```

The manifest clones this private repo via your GitHub credentials and installs files into `%USERPROFILE%\.claude\`. Future updates: `scoop update caddy-paul`.

## What's inside

```
commands/paul/    PAUL slash commands (/paul:init, /paul:plan, /paul:audit, /paul:apply, /paul:unify, /paul:add-phase, etc.)
framework/        PAUL framework data (phase-types, references, workflows)
agents/           PAUL specialist subagents (research, planning, review, and build-stream agents)
```

Run `/paul:init` in any project to set up structured PAUL planning. Then `/paul:plan` to design the next chunk of work, optionally `/paul:audit` to run a senior-engineer review, `/paul:apply` to execute, and `/paul:unify` to close the loop. The `phase-types/` and `references/` directories under `framework/` provide the templates and rubrics PAUL uses under the hood.

**Note:** as of v0.2.0 the specialist subagents ship with the distribution and are linked into `~/.claude/agents/` by `caddy-link`. See VERSION-NOTES.md for what each release contains.

## License

Proprietary. All rights reserved.

This software is licensed to Caddy customers under the terms of their active subscription. Redistribution, modification, or use beyond an active Caddy subscription is prohibited. See LICENSE for full terms.

## Support

Questions, install issues, framework questions: **hi@meetcaddy.com**

Operator: Tucker Bern (Manager, Orbital Access LLC d/b/a Meet Caddy)
