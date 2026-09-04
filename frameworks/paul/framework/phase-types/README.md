# Phase Types, README

Reusable categories of project work, shipped with PAUL framework. Used by Phase Auto-Detection (sprint item 3b) to recommend the right phases when adding work to a project's roadmap.

**Status (2026-05-04):** Foundation only. Files in this directory are inert data until Phase Auto-Detection 3b runtime ships. Adding new phase-type files is safe; nothing breaks.

---

## What's in this directory

```
phase-types/
├── SCHEMA.md                ← Schema definition. Read this before authoring new phase types.
├── README.md                ← This file.
├── dev/                     ← Software development phase types (9)
│   ├── scaffold-phase.md
│   ├── spec-phase.md
│   ├── exploration-phase.md
│   ├── ultraplan-phase.md
│   ├── secure-phase.md
│   ├── ui-phase.md
│   ├── ai-integration-phase.md
│   ├── validate-phase.md
│   └── review-phase.md
└── marketing-and-ops/       ← Marketing and operations phase types (8)
    ├── campaign-phase.md
    ├── content-series-phase.md
    ├── outreach-phase.md
    ├── video-production-phase.md
    ├── landing-page-phase.md
    ├── customer-lifecycle-phase.md
    ├── deal-pursuit-phase.md
    └── process-doc-phase.md
```

---

## How phase types work (simplified)

1. User runs `/paul:add-phase` (or the auto-detection layer when 3b ships)
2. PAUL/Caddy reads the project description, the roadmap so far, and any file signals
3. The trigger metadata in each phase-type file is matched against project context
4. Matching phase types are presented to the user as recommendations with cut/add/expand/approve options
5. User confirms one or more phase types
6. The phase-type template body is used to populate the new phase's scope/goal/plans in `.paul/ROADMAP.md`
7. The roadmap phase optionally records `phase_type:` metadata so the phase remembers its template lineage

**This file describes the WHY and HOW. The schema spec is in `SCHEMA.md`. Each phase-type file is the WHAT for one specific category.**

---

## Three layers of phase vocabulary in PAUL

Don't confuse them:

| Layer | Lives in | Example | Purpose |
|-------|----------|---------|---------|
| **Loop phases** | `references/loop-phases.md` | PLAN, APPLY, UNIFY | Universal execution lifecycle every plan goes through |
| **Roadmap phases** | `.paul/ROADMAP.md` (per-project) | "Phase 3: Authentication" | Project-specific milestones broken into phases |
| **Phase types** | `phase-types/` (this dir) | secure-phase, ui-phase | Reusable category templates that roadmap phases optionally reference |

A roadmap phase can reference a phase type (via optional `phase_type:` field), or stand on its own. Phase types ARE NOT mandatory.

---

## Categories

### `dev/`, Software development

Phase types for projects that involve writing, reviewing, or shipping code. Common examples: setting up a new project, integrating an AI feature, performing security review, validating an implementation.

### `marketing-and-ops/`, Marketing and operations

Phase types for projects that involve campaigns, content, outreach, customer lifecycle work, or operational documentation. Common examples: launching a marketing campaign, building a content series, running an outreach sequence, onboarding a customer.

**Many real projects mix both categories.** A SaaS launch might involve `product-launch` (marketing-and-ops) AND `ai-integration-phase` (dev) AND `secure-phase` (dev). Auto-detection 3b will recommend across both pools when the project description spans them.

---

## Adding a new phase type

1. Read `SCHEMA.md` to understand the required frontmatter and file structure
2. Decide which category (`dev/` or `marketing-and-ops/`)
3. Copy an existing phase-type file as a template
4. Fill in the frontmatter (especially `triggers`, without them, auto-detection can't find your phase type)
5. Fill in the markdown body following the schema's structure
6. Document `sources` if the phase type was merged from external work
7. Cross-reference any related PAUL workflows in `related_paul_workflows`
8. Validate: at minimum, all required schema fields are present

When the validator from 3b ships, it will check every file in this directory. Until then, manual review against `SCHEMA.md` is the validation step.

---

## Phase type vs PAUL command

A phase type is the CATEGORY OF WORK. The corresponding PAUL command (e.g., `/paul:secure-phase`) is the action you run to enter that phase. They're paired but distinct:

- **Phase type file** ships in framework, defines triggers + template
- **PAUL command** ships in commands directory, invokes the phase type's workflow

Most phase types in this directory have corresponding `/paul:*` commands queued in the Caddy v3 sprint (see `admin/research/extraction-tracker.md` section V3.2). Phase-type files ship first; commands come later when ported from GSD source.

---

## Maintenance

- Phase types should evolve as Caddy customers' projects evolve
- Quarterly review: which phase types are getting auto-recommended, which never fire?
- Phase types that never fire after 12 months are candidates for removal
- New patterns observed in customer projects → candidates for new phase types

---

## Related docs

- `SCHEMA.md`, full schema spec
- `~/.claude/paul-framework/templates/ROADMAP.md`, roadmap template that references phase types via optional `phase_type:` field
- `~/.claude/paul-framework/workflows/discuss-phase.md`, phase discussion workflow
- `~/.claude/paul-framework/workflows/roadmap-management.md`, add/remove phase workflow (will integrate phase-type auto-detection in 3b)
- `admin/research/extraction-tracker.md`, Caddy v3 tracker, especially V3.6 strategic capabilities section
