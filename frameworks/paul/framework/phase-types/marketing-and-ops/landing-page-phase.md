---
schema_version: 1.0
name: landing-page-phase
display_name: Landing Page Phase
category: marketing-and-ops
purpose: Landing page design, copy, and conversion optimization. Two modes: page-only (just the landing page) or with-lead-gen (page + traffic strategy + capture mechanism).
modes: [page-only, with-lead-gen]
default_mode: page-only
duration: medium
risk_level: medium
triggers:
  keywords: [landing page, landing, sales page, conversion, lead gen, capture page, opt-in, sales funnel, lead magnet]
  patterns: ['(landing|sales|capture|opt.in)\s+page', 'lead\s+(gen|generation|magnet)', '(build|create|design)\s+(a|the)\s+(landing|page)']
  file_signals: [landing/, pages/landing*, *.landing.tsx, hero-section]
  required_after: []
  required_before: [campaign-phase, ship-phase]
  recommended_for: [Caddy customers running marketing, product launches, lead-gen campaigns, paid traffic landing destinations]
recommended_skills: [doc, draft, humanizer, brand-kit, frontend-design, geo-citability, geo-content]
related_paul_workflows: []
sources: [Caddy native, synthesizes doc + humanizer + brand-kit + frontend-design + GEO skills into landing page workflow]
---

# Landing Page Phase

## Purpose

Build a landing page (or sales page) optimized for conversion. Two modes:

- **`page-only` mode**, just the page (design + copy + visuals). Customer handles traffic separately.
- **`with-lead-gen` mode**, page + traffic strategy + capture mechanism (form, offer, lead magnet). Full lead-gen system.

Both modes apply Caddy's design discipline: voice consistency (humanizer), brand consistency (brand-kit), visual quality (frontend-design hooks/skills), and AI-search optimization (GEO skills).

## When to recommend

### page-only mode
- Customer needs a landing page for a campaign
- Product launch needs a hero page
- Existing landing page needs refresh
- Caddy customer building their own marketing site

### with-lead-gen mode
- Customer needs to GENERATE leads (not just receive traffic)
- Lead magnet involved (free guide, free assessment, free tier)
- Capture form + nurture sequence required
- Pairs with `outreach-phase` for follow-up

## Modes

### Mode: page-only
Single landing page. Walks through: positioning → hero copy → supporting sections (proof, features, CTA) → design → copy iteration → publish.

### Mode: with-lead-gen
Page + traffic + capture. Walks through: positioning → lead magnet design → page (hero + magnet copy + capture form) → traffic strategy (paid / organic / outreach) → nurture sequence (orchestrates outreach-phase nurture-sequence mode) → measurement.

## Phase template (page-only mode)

### Goal
Produce a published landing page with strong conversion potential. Output: live page + analytics setup + copy + visual assets.

### Scope
- Positioning (audience, message, why-this-page)
- Hero (headline, subheadline, primary CTA, hero visual)
- Supporting sections (social proof, features, secondary CTAs)
- Voice consistency (humanizer)
- Brand consistency (brand-kit)
- Visual quality (no AI-template aesthetic, design-quality hook applies)
- AI-search optimization (GEO skills for citability + structured data)
- Analytics setup (event tracking)
- Publish + verify

### Plans (suggested decomposition)
- [ ] Plan 1: Positioning brief (audience, message, primary outcome)
- [ ] Plan 2: Hero copy (orchestrates `/draft` + humanizer)
- [ ] Plan 3: Supporting section copy (features, proof, CTAs)
- [ ] Plan 4: Visual brief + asset list (orchestrates video/image skills if needed)
- [ ] Plan 5: Page build (orchestrates `frontend-design` if hand-coded; or pasted into Framer per Tucker's `landing-framer` decision)
- [ ] Plan 6: AI-search optimization (orchestrates `geo-citability` + `geo-content` + `geo-schema`)
- [ ] Plan 7: Analytics setup (event tracking, conversion goals)
- [ ] Plan 8: Publish + smoke test (mobile + desktop, all CTAs work)

## Phase template (with-lead-gen mode)

### Goal
Produce a complete lead-gen system: landing page + lead magnet + capture form + nurture sequence + traffic plan.

### Plans (additional to page-only)
- [ ] Plan A: Lead magnet design (what's the offer? free guide / assessment / template / tier?)
- [ ] Plan B: Lead magnet creation (orchestrates `/doc` for guides; other skills as needed)
- [ ] Plan C: Capture form design + integration (Stripe or Mailchimp or Caddy customer's chosen tool)
- [ ] Plan D: Traffic strategy (paid / organic / outreach mix)
- [ ] Plan E: Nurture sequence (orchestrates `outreach-phase` in nurture-sequence mode)
- [ ] Plan F: Conversion measurement (lead → booked call rate)

### Dependencies
- Voice fingerprint exists (humanizer)
- Brand kit exists
- Decision on hosting (Framer per Tucker / hand-coded / customer's CMS)
- For with-lead-gen: capture-form integration ready (Stripe/Mailchimp/etc.)

### Verification
- Page is live and verified mobile + desktop
- All CTAs function (no broken links, forms submit successfully)
- Voice consistent with brand
- Visual quality is original (no generic-AI-aesthetic markers, passes design-quality-check hook)
- AI-search optimization applied (llms.txt referenced, schema markup present)
- Analytics tracking confirmed
- For with-lead-gen: lead capture confirmed end-to-end (test submission lands in destination)

## Skills orchestrated

1. `doc`, for lead magnet content (with-lead-gen mode)
2. `draft`, copy production
3. `humanizer`, voice consistency on all copy
4. `brand-kit`, visual + tone discipline
5. `frontend-design`, page build (if hand-coded; not needed if pasted into Framer)
6. `geo-citability`, make page citable by AI search
7. `geo-content`, content quality for AI search
8. `geo-schema`, structured data for AI discoverability
9. `outreach-phase` (recursively), for nurture sequence in with-lead-gen mode
10. Video skills, if hero video needed

## Source notes

**Caddy native phase type, no external repo source.** Synthesized from Tucker's existing Caddy skill catalog (especially the rich GEO skill set installed for AI-search optimization).

**Why merge page-only + lead-gen into one phase type:** they share 80% of the workflow (positioning, copy, design, publish). The lead-gen mode adds 4-6 plans on top (lead magnet, capture, traffic, nurture). Merging keeps the orchestration backbone consistent; mode flag captures the scope difference.

**Caddy-specific design:**
- AI-search optimization is REQUIRED (geo skills). This is a Caddy differentiator, most landing pages don't optimize for AI search.
- design-quality-check hook coverage is REQUIRED (visual quality discipline; no AI-template aesthetic). Hook fires automatically during edits.
- llms.txt cross-reference: Caddy's customer-facing landing strategy includes shipping llms.txt; landing pages should reference it for AI-discoverability.
- Framer integration: per Tucker's decision (`project_command_center_landing_framer.md`), Caddy ships pages to Framer. Phase 5 in the template covers either path (hand-coded OR Framer paste).

**Pairs with:**
- `campaign-phase` (campaigns often need a campaign-specific landing page)
- `outreach-phase` (with-lead-gen mode invokes nurture-sequence)
- `content-series-phase` (testimonial-collection mode produces social proof for landing page)
- `video-production-phase` (hero video assets)

## Anti-patterns

- DO NOT skip AI-search optimization. Caddy positioning includes "ready for AI-first search era." Landing pages without GEO are leaving discovery on the table.
- DO NOT use generic templates. design-quality-check hook will warn; don't override.
- DO NOT skip the analytics setup. Page without conversion tracking can't be improved.
- DO NOT auto-add lead magnet for every landing page. Lead magnet is a deliberate choice (with-lead-gen mode); page-only mode is valid for many use cases.
- DO NOT publish without testing the form/CTAs. Broken landing page is worse than no landing page.
- DO NOT confuse this with marketing site work (full multi-page site). Landing page = single page focused on one outcome.
