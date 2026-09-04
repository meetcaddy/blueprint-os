---
schema_version: 1.0
name: content-series-phase
display_name: Content Series Phase
category: marketing-and-ops
purpose: Multi-piece content production with shared theme. Three modes for editorial series, case study collection, and testimonial collection. Voice-consistent across all pieces.
modes: [editorial-series, case-study, testimonial-collection]
default_mode: editorial-series
duration: long
risk_level: low
triggers:
  keywords: [content series, blog series, newsletter series, podcast season, case study, testimonial, customer story, multi-part content]
  patterns: ['(blog|newsletter|podcast|video)\s+series', '(content|editorial)\s+(series|sprint)', '(case stud|testimonial)']
  file_signals: []
  required_after: []
  required_before: []
  recommended_for: [thought-leadership content, customer story collection, brand-building, SEO content surface area expansion]
recommended_skills: [doc, humanizer, draft, digest, contacts-update]
related_paul_workflows: []
sources: [Caddy native, synthesizes doc + humanizer + draft + digest skills into a multi-piece content workflow]
---

# Content Series Phase

## Purpose

Produce a multi-piece content sprint with a shared theme. Three distinct modes for the three most common multi-piece content shapes:

- **`editorial-series` mode**, blog series, newsletter sequence, podcast season, video series. Multiple pieces of original content with shared theme/audience/cadence.
- **`case-study` mode**, collect, write, and publish customer case studies. Includes outreach to customers, interviews, narrative writing, approval, publication.
- **`testimonial-collection` mode**, collect, package, and surface customer testimonials. Lighter than case studies; focused on social proof.

All three modes enforce voice consistency via the humanizer skill. All three plan the entire series upfront, then produce piece-by-piece.

## When to recommend

### editorial-series mode
- Multi-part content commitment (e.g., "5-part series on X")
- Newsletter restart or new newsletter format
- Podcast season planning
- Video series planning
- Thought-leadership content commitment

### case-study mode
- Customer wins exist that haven't been packaged
- Sales team needs proof for prospects
- Marketing site lacks social proof
- Vertical-specific case studies needed (Caddy customer in healthcare wants healthcare case studies)

### testimonial-collection mode
- Launching a landing page that needs social proof
- Sales motion needs trust signals
- Lighter than full case studies (quote + name + company, not full narrative)

## Modes

### Mode: editorial-series
Multi-piece original content. Walks through: theme + audience + cadence → outline all pieces → produce piece-by-piece → publish on schedule → measure.

### Mode: case-study
Customer story collection + writing + publication. Walks through: candidate identification → outreach → interview → narrative writing → customer approval → publication.

### Mode: testimonial-collection
Lighter than case-study. Walks through: candidate identification → outreach (request quote + permission) → quote collection → packaging (graphics, landing page section) → publication.

## Phase template (editorial-series mode)

### Goal
Produce a complete content series of N pieces with consistent voice and theme. Output: series plan, all pieces written and published, performance measurement.

### Scope
- Define theme, audience, cadence, piece count
- Outline all pieces upfront (don't write piece 1 then figure out piece 2)
- Voice consistency via humanizer
- Publication on schedule
- Performance measurement

### Plans (suggested decomposition)
- [ ] Plan 1: Series brief (theme, audience, cadence, piece count, channel)
- [ ] Plan 2: Outline all N pieces (titles, hooks, key points, CTAs)
- [ ] Plan 3: Produce piece 1 (orchestrates `/doc` or `/draft` with humanizer)
- [ ] Plan 4-N: Produce remaining pieces
- [ ] Plan N+1: Publication schedule + execution
- [ ] Plan N+2: Performance measurement (engagement, traffic, conversions)

## Phase template (case-study mode)

### Goal
Produce N polished customer case studies, each customer-approved and ready to publish.

### Plans
- [ ] Plan 1: Identify case study candidates (customers with measurable wins)
- [ ] Plan 2: Outreach + permission (template email via `/draft`)
- [ ] Plan 3: Interview each candidate (live or async), capture their words
- [ ] Plan 4: Narrative writing for each case study (orchestrates `/doc` + humanizer)
- [ ] Plan 5: Customer approval pass (send draft, capture edits)
- [ ] Plan 6: Publication (landing page section, sales enablement, blog post)

## Phase template (testimonial-collection mode)

### Goal
Collect N customer testimonials (quotes + permission to use), packaged for use across landing page, sales decks, marketing site.

### Plans
- [ ] Plan 1: Identify candidates (customers who've expressed satisfaction)
- [ ] Plan 2: Outreach + permission request (template via `/draft`)
- [ ] Plan 3: Quote collection (capture as customer wrote it; minimal editing)
- [ ] Plan 4: Packaging (testimonial section design, sales deck slides)
- [ ] Plan 5: Publication

### Verification
- All pieces / case studies / testimonials produced
- Voice consistency verified (humanizer applied uniformly)
- For case-study and testimonial modes: customer approval recorded
- Publication completed
- Measurement (where applicable) recorded

## Skills orchestrated

1. `doc`, long-form piece writing
2. `draft`, outreach emails (case study / testimonial mode)
3. `humanizer`, voice consistency across all pieces
4. `digest`, for newsletter modes specifically (synthesizes content into newsletter format)
5. `contacts-update`, when collecting from customers, update contact records

## Source notes

**Caddy native phase type, no external repo source.** Synthesized from Tucker's existing Caddy skills.

**Why merge case-study + testimonial + editorial-series into one phase type:** all three are multi-piece content sprints with shared theme. They differ in INTENT (original vs customer-sourced) and FORMAT (full narrative vs quote), not in shape. Same orchestration backbone (theme → outline → produce → publish → measure).

**Caddy-specific design:**
- Voice consistency via humanizer is non-negotiable across all modes (one of the things Caddy uniquely provides)
- Customer approval is required for case-study and testimonial modes (legal + relationship hygiene)
- Outline-all-pieces-upfront is the discipline that distinguishes this phase from one-off content

**Pairs with:**
- `campaign-phase` (campaigns often include a content series)
- `landing-page-phase` (testimonials often land on a landing page)
- `customer-lifecycle-phase` (case study candidates surface during mid-life and offboarding)

## Anti-patterns

- DO NOT skip outlining all pieces upfront. Series quality drops when pieces are written reactively.
- DO NOT skip voice consistency check. Multi-piece content with drifting voice reads as multiple authors.
- DO NOT publish case studies without explicit customer approval. Legal + relationship damage.
- DO NOT confuse editorial-series with campaign-phase. A campaign HAS a content series; the series is one element. Campaign is bigger scope.
- DO NOT use this phase for one-off content (single post, single email). Use `/doc` or `/draft` directly.
