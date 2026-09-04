# Skillsmith

> **Caddy customer-disk framework.** This repository ships Skillsmith as part of the Caddy operator-rhythm experience. Customers install via the Caddy Homebrew tap (macOS) or Scoop bucket (Windows); see "Installation" below.

Skillsmith is a meta-framework for building Claude Code skills. Guides you through discovery (what to build), scaffolding (generating compliant files), distilling (chunking source material), and auditing (checking compliance) using standardized syntax specs.

## Ownership

Owned and maintained by Orbital Access LLC d/b/a Meet Caddy.

Customer-facing brand: Caddy. Your unfair advantage.
Support: hi@meetcaddy.com

## Version

**v0.1.0** (initial Caddy distribution baseline; tracks Caddy plugin v0.1.x cadence)

Future updates ship as new tagged releases. Customers receive them via `brew upgrade caddy-skillsmith` (Mac) or `scoop update caddy-skillsmith` (Windows). The Caddy Homebrew tap and Scoop bucket pin to specific tags here.

## Installation

> **For Caddy customers only.** This is a private repository; access is granted via GitHub collaborator add as part of your Caddy onboarding. Installation flows through the Caddy Homebrew tap or Scoop bucket; you do not need to clone this repo directly.

**macOS (via Homebrew):**

```sh
brew tap meetcaddy/caddy
brew install caddy-skillsmith
```

The formula clones this private repo via your GitHub credentials and installs files into `~/.claude/`. Future updates: `brew upgrade caddy-skillsmith`.

**Windows (via Scoop):**

```sh
scoop bucket add caddy https://github.com/meetcaddy/scoop-caddy
scoop install caddy-skillsmith
```

The manifest clones this private repo via your GitHub credentials and installs files into `%USERPROFILE%\.claude\`. Future updates: `scoop update caddy-skillsmith`.

> **Heads-up:** the Homebrew tap (`meetcaddy/homebrew-caddy`) and Scoop bucket (`meetcaddy/scoop-caddy`) are queued in Plans 7.5-02 + 7.5-03. Until those repos exist, installation runs through the manual onboarding script Tucker walks each customer through. This README will be updated to reflect the live install paths once the tap and bucket are stood up.

## What's inside

```
commands/skillsmith/    Skillsmith slash command + rules/tasks/templates subdirs
specs/                  Skill-creation specs (checklists, context, entry-point,
                        frameworks, rules, tasks, templates)
```

Run `/skillsmith` when you want to build or audit a Claude Code skill. The suite walks you through what to build, scaffolds the directory structure, distills source material into framework chunks, and audits existing skills for syntax compliance. The `specs/` directory documents the syntax conventions Skillsmith enforces.

## License

Proprietary. All rights reserved.

This software is licensed to Caddy customers under the terms of their active subscription. Redistribution, modification, or use beyond an active Caddy subscription is prohibited. See LICENSE for full terms.

## Support

Questions, install issues, framework questions: **hi@meetcaddy.com**

Operator: Tucker Bern (Manager, Orbital Access LLC d/b/a Meet Caddy)
