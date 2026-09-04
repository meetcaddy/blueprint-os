# SEED

> **Caddy customer-disk framework.** This repository ships SEED as part of the Caddy operator-rhythm experience. Customers install via the Caddy Homebrew tap (macOS) or Scoop bucket (Windows); see "Installation" below.

SEED is a lightweight pre-PAUL ideation framework. Capture an idea, work through scoping questions, and graduate the idea into a PAUL-managed project when it's ready to build.

## Ownership

Owned and maintained by Orbital Access LLC d/b/a Meet Caddy.

Customer-facing brand: Caddy. Your unfair advantage.
Support: hi@meetcaddy.com

## Version

**v0.1.0** (initial Caddy distribution baseline; tracks Caddy plugin v0.1.x cadence)

Future updates ship as new tagged releases. Customers receive them via `brew upgrade caddy-seed` (Mac) or `scoop update caddy-seed` (Windows). The Caddy Homebrew tap and Scoop bucket pin to specific tags here.

## Installation

> **For Caddy customers only.** This is a private repository; access is granted via GitHub collaborator add as part of your Caddy onboarding. Installation flows through the Caddy Homebrew tap or Scoop bucket; you do not need to clone this repo directly.

**macOS (via Homebrew):**

```sh
brew tap meetcaddy/caddy
brew install caddy-seed
```

The formula clones this private repo via your GitHub credentials and installs files into `~/.claude/`. Future updates: `brew upgrade caddy-seed`.

**Windows (via Scoop):**

```sh
scoop bucket add caddy https://github.com/meetcaddy/scoop-caddy
scoop install caddy-seed
```

The manifest clones this private repo via your GitHub credentials and installs files into `%USERPROFILE%\.claude\`. Future updates: `scoop update caddy-seed`.

> **Heads-up:** the Homebrew tap (`meetcaddy/homebrew-caddy`) and Scoop bucket (`meetcaddy/scoop-caddy`) are queued in Plans 7.5-02 + 7.5-03. Until those repos exist, installation runs through the manual onboarding script Tucker walks each customer through. This README will be updated to reflect the live install paths once the tap and bucket are stood up.

## What's inside

```
commands/seed/    SEED slash commands (/seed:capture, /seed:graduate, etc.)
                  plus checklists/ and data/ directories
```

Run `/seed:capture` when you have an idea you're not sure how to pursue yet. SEED walks you through scoping questions, captures the idea as a `PLANNING.md` in a `projects/` subfolder, then later you can `/seed:graduate` it into an `apps/` or `workflows/` project once it's ready for structured PAUL planning.

This Caddy distribution includes a type-aware routing customization to `/seed:graduate` that routes ideas into the correct workspace category (apps / workflows / other) on graduation.

## License

Proprietary. All rights reserved.

This software is licensed to Caddy customers under the terms of their active subscription. Redistribution, modification, or use beyond an active Caddy subscription is prohibited. See LICENSE for full terms.

## Support

Questions, install issues, framework questions: **hi@meetcaddy.com**

Operator: Tucker Bern (Manager, Orbital Access LLC d/b/a Meet Caddy)
