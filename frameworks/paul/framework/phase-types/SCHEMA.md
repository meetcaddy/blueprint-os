# Phase Type Schema

**Version:** 1.0
**Last updated:** 2026-05-04
**Status:** Foundation. Files in this directory validate against this schema. Runtime auto-detection logic (which uses these files) is built in Phase Auto-Detection 3b (separate sprint item).

---

## What a phase type is

A **phase type** is a reusable category of project work. It describes a recurring kind of phase that any project might need (security review, UI development, AI integration, content series, customer onboarding, etc.). Phase types ship with PAUL framework and are discovered by Phase Auto-Detection.

Phase types are NOT roadmap phases. Roadmap phases live in a project's `.paul/ROADMAP.md` and are project-specific. A roadmap phase MAY reference a phase type via the optional `phase_type:` field; phase types provide the template + the trigger metadata that powers auto-recommendation.

---

## How phase types fit into PAUL

PAUL has three layers of "phase" vocabulary. Don't confuse them.

```
┌─────────────────────────────────────────────────────────────────┐
│ LOOP PHASES (universal execution lifecycle)                     │
│ Every plan goes through PLAN → APPLY → UNIFY                    │
│ Defined in: ~/.claude/paul-framework/references/loop-phases.md   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ ROADMAP PHASES (project-specific milestones broken into phases) │
│ Defined per-project in: .paul/ROADMAP.md                        │
│ Example: "Phase 3: Authentication", "Phase 4: Billing"          │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│ PHASE TYPES (reusable categories) ← THIS LAYER                  │
│ Shipped with PAUL framework: ~/.claude/paul-framework/phase-types/│
│ Example: secure-phase, ui-phase, ai-integration-phase           │
│ A roadmap phase OPTIONALLY references one via phase_type: field │
└─────────────────────────────────────────────────────────────────┘
```

**Key principle:** phase types are RECOMMENDATIONS, not REQUIREMENTS. A roadmap phase without a `phase_type:` field is always valid. Phase types are the catalog Caddy/PAUL recommends from when adding new phases, they reduce cognitive load, they don't enforce structure.

---

## File format

Every phase-type file is a markdown file with YAML frontmatter at the top, followed by a markdown body that becomes the phase's scope/goal/plans template when the phase type is accepted into a project's roadmap.

```markdown
---
schema_version: 1.0
name: secure-phase
display_name: Security Review Phase
category: dev | marketing-and-ops
purpose: One-sentence purpose statement
modes: [check, audit, full]              # Optional list of mode flags
default_mode: audit                       # Required if modes is present
duration: short | medium | long           # Effort signal
risk_level: low | medium | high           # What's at stake if skipped
triggers:
  keywords: [list, of, words, that, signal, this, phase, applies]
  patterns: [".*regex.*", ".*another regex.*"]
  file_signals: [list, of, file, names, or, extensions]
  required_after: [list-of-phase-types]   # Phases that must precede this
  required_before: [list-of-phase-types]  # Phases that must follow this
  recommended_for: [project-shape-1, project-shape-2]
recommended_skills: [skill-1, skill-2]    # Caddy skills this phase orchestrates
related_paul_workflows: [paul-command-1]  # Existing PAUL workflows that pair
sources: [source-repo-1, source-repo-2]   # Where the merge came from
---

# {Display Name}

## Purpose

One paragraph: what this phase accomplishes and why a project would run it.

## When to recommend

Explicit conditions auto-detection looks for. Mirror the triggers metadata in prose.

## Modes

If the phase has modes, document each:

### Mode: check
Light version. When to pick it.

### Mode: audit
Default version. When to pick it.

### Mode: full
Heavy version. When to pick it.

## Phase template (becomes the roadmap phase scope when accepted)

### Goal
What this phase delivers (becomes the phase Goal in ROADMAP.md).

### Scope
Bullet list of deliverables.

### Plans (suggested decomposition)
- [ ] Plan 1: ...
- [ ] Plan 2: ...
- [ ] Plan 3: ...

### Dependencies
What must be true/built before this phase starts.

### Verification
How you know this phase is done.

## Skills orchestrated

List of Caddy skills this phase invokes, in typical order:

1. `skill-name`, what it does in this phase
2. `another-skill`, what it does

## Source notes

Where this phase type came from and what was merged. (For audit/transparency.)

## Anti-patterns

What this phase type is NOT for (so it doesn't get over-applied).
```

---

## Required frontmatter fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `schema_version` | string | Yes | Version of this schema the file validates against. Currently `1.0`. |
| `name` | string | Yes | File-name slug. Lowercase, hyphenated. Ends in `-phase`. |
| `display_name` | string | Yes | Human-readable name shown in recommendations. |
| `category` | enum | Yes | `dev` or `marketing-and-ops`. Determines which subdirectory the file lives in. |
| `purpose` | string | Yes | One-sentence purpose. |
| `duration` | enum | Yes | `short` (hours), `medium` (1-3 days), `long` (week+). |
| `risk_level` | enum | Yes | `low`, `medium`, `high`. What's at stake if this phase is skipped. |
| `triggers` | object | Yes | See triggers section below. |

## Optional frontmatter fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `modes` | list | If applicable | Mode flags this phase supports. Omit if the phase has a single shape. |
| `default_mode` | enum | Required if `modes` present | Default mode if user doesn't specify. |
| `recommended_skills` | list | Optional | Caddy skill names this phase typically orchestrates. |
| `related_paul_workflows` | list | Optional | Existing PAUL commands/workflows that pair with this phase. |
| `sources` | list | Recommended | Where the merge came from (for audit). |

---

## Triggers object

The trigger metadata is what powers Phase Auto-Detection (3b, runtime). Auto-detection scans these against a project's description, files, and other context.

```yaml
triggers:
  keywords: []           # Words/phrases that signal this phase applies
  patterns: []           # Regex patterns for more flexible matching
  file_signals: []       # File names or extensions whose presence indicates this phase
  required_after: []     # Phase types that must precede this one in the roadmap
  required_before: []    # Phase types that must follow this one
  recommended_for: []    # Free-text project shapes ("any project handling user data")
```

**All trigger arrays are optional.** A phase type with empty triggers can still be manually selected by users; it just won't be auto-recommended.

**Triggers are signals, not commands.** Auto-detection (3b) collects all matching phase types and presents them to the user as recommendations with cut/add/expand/approve options. Triggers never auto-add a phase to a roadmap without user confirmation.

---

## Schema versioning

Every phase-type file MUST declare `schema_version` in its frontmatter. When this schema evolves:

- **Patch (1.0 → 1.0.1):** clarifications, no field changes. Files don't need updates.
- **Minor (1.0 → 1.1):** new optional fields. Files don't need updates but may opt in.
- **Major (1.0 → 2.0):** breaking field changes. Files need migration. Provide a migration guide.

Phase Auto-Detection (3b) will support reading multiple schema versions until a deprecation is announced.

---

## Validation

Phase Auto-Detection (3b) will include a validator that checks every phase-type file against this schema. Until then, validate by hand against the required fields list above.

---

## Anti-patterns

**Don't ship a phase type without triggers.** A phase type with no triggers can't be auto-recommended; it's dead catalog weight unless customers manually browse the registry.

**Don't ship a phase type that duplicates an existing PAUL workflow.** If `paul:research-phase` already covers the use case, don't ship `research-spike-phase`. Cross-reference instead.

**Don't ship a phase type with arbitrary modes.** Each mode must have a distinct purpose, distinct triggers, distinct deliverables. If two modes look identical, collapse them.

**Don't bake project-specific assumptions into a phase type.** Phase types are reusable templates. If the template only fits one operator's projects, it belongs in that project's `.paul/`, not in the PAUL framework.

**Don't expand the schema casually.** Every new field is a load-bearing contract that every phase type must respect. Push back on schema additions.
