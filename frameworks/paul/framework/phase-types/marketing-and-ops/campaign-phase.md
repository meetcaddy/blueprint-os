---
schema_version: 1.0
name: campaign-phase
display_name: Campaign Phase
category: marketing-and-ops
purpose: Multi-step marketing campaign execution. Four modes covering launches, product releases, brand refreshes, and SEO campaigns. Orchestrates positioning, channels, assets, schedule, and KPIs.
modes: [launch, product, brand-refresh, seo]
default_mode: launch
duration: long
risk_level: medium
triggers:
  keywords: [campaign, launch, product launch, brand refresh, brand update, SEO campaign, marketing push, go-to-market, GTM]
  patterns: ['(launch|launching)\s+(a|the|our|new)\s+\w+', '(GTM|go.to.market)', 'brand\s+(refresh|update|relaunch)', 'SEO\s+(campaign|push|sprint)']
  file_signals: []
  required_after: []
  required_before: []
  recommended_for: [Caddy customers running their own marketing, product launches, anything multi-channel and time-bound]
recommended_skills: [pipeline, doc, draft, humanizer, brand-kit]
related_paul_workflows: []
sources: [Caddy native, synthesizes pipeline + doc + draft + humanizer + brand-kit skills into a campaign workflow]
---

# Campaign Phase

## Purpose

Orchestrate a multi-step marketing campaign from positioning through execution to measurement. Four modes for the four most common campaign shapes:

- **`launch` mode**, generic marketing campaign launch (announcement, content, paid, organic, email)
- **`product` mode**, product launch (new feature, new product, new release; includes pre-launch buzz, launch day, post-launch retention)
- **`brand-refresh` mode**, voice/visual identity update or evolution
- **`seo` mode**, multi-week SEO improvement sprint

Customer doesn't have to remember the steps. Phase walks them through positioning, channels, assets, schedule, KPIs, and post-campaign measurement.

## When to recommend

Auto-detection should recommend campaign-phase whenever:
- "I want to launch X" / "We're launching Y next month"
- Multi-channel marketing work is in scope
- Time-bound marketing push (launch date, season, event tie-in)
- Brand-level changes (visual identity, voice update, naming change)
- SEO sprint targeting specific keywords or content surface area

## Modes

### Mode: launch
Generic campaign launch. Suitable for: feature releases, partnership announcements, content series openings, event-tied campaigns. Walks through: positioning → channels → assets → schedule → KPIs → execution → post-campaign measurement.

### Mode: product
Product launch with pre/launch/post structure. Pre-launch: positioning, audience research, asset preparation, pre-launch buzz (email list warming, sneak peeks). Launch day: announcement push, demo, social. Post-launch: retention nurture, case studies, testimonial collection.

### Mode: brand-refresh
Voice/visual identity update. Walks through: brand audit → vision statement → voice fingerprint update (via humanizer setup re-run) → visual refresh → asset migration → public reveal.

### Mode: seo
Multi-week SEO improvement sprint. Walks through: keyword research → content gap analysis → on-page optimization → content production → backlink strategy → measurement.

## Phase template (launch mode)

### Goal
Run a complete marketing campaign from positioning through measurement. Output: campaign brief, asset library, execution log, post-campaign report.

### Scope
- Positioning (who, what, why now)
- Channel selection (email, social, paid, organic, partner, etc.)
- Asset production (copy, images, video, landing pages)
- Schedule (pre-launch / launch / post-launch)
- KPIs (define what success means before launching)
- Execution (run the campaign)
- Measurement (post-campaign report)

### Plans (suggested decomposition)
- [ ] Plan 1: Positioning brief (audience, message, why-now)
- [ ] Plan 2: Channel mix + schedule
- [ ] Plan 3: Asset production (orchestrates `/draft`, `/doc`, `humanizer`, video skills as needed)
- [ ] Plan 4: KPI definition + measurement plan
- [ ] Plan 5: Pre-launch buzz (warm email list, social tease)
- [ ] Plan 6: Launch execution (coordinate channels)
- [ ] Plan 7: Post-launch nurture
- [ ] Plan 8: Measurement + post-campaign report

### Dependencies
- Voice fingerprint exists (humanizer setup complete) for consistent campaign voice
- Brand kit exists for visual consistency
- Optional: pipeline exists for tracking deals/leads generated

### Verification
- All assets produced and ready
- Schedule executed (or documented if changed)
- KPIs measured
- Post-campaign report exists with what worked + what didn't

## Skills orchestrated

1. `pipeline`, track campaign-generated leads/deals
2. `doc`, generate campaign brief, content briefs, asset specs
3. `draft`, voice-tuned email content (announcements, nurture)
4. `humanizer`, ensure all campaign content matches voice fingerprint
5. `brand-kit`, ensure visual + tone consistency
6. Video skills (06-motion-design-ad, 07-ecommerce-ad, 12-brand-story, etc.), if campaign involves video assets

## Source notes

**Caddy native phase type, no external repo source.** Synthesized from the operator's installed Caddy skill catalog into a coherent campaign workflow.

**What each existing Caddy skill contributes:**
- `pipeline`, deal/lead tracking surface for campaign attribution
- `doc`, long-form content generation (campaign briefs, landing copy, blog posts)
- `draft`, short-form email composition with voice fingerprint
- `humanizer`, voice consistency layer across all campaign assets
- `brand-kit`, visual + tone discipline
- Video skills (15 installed), campaign video assets per intent

**Why ship as a phase type instead of a skill:** campaign work is multi-step and time-bound. Skills do single tasks. The phase orchestrates skills + adds structure (positioning → channels → schedule → KPIs → measurement). Customer thinks in campaigns, not in skill invocations.

**Mode rationale:** the four modes capture the four most common campaign shapes Caddy customers run. Other campaign shapes (e.g., recruiting campaign, event campaign) are deferred until customer demand surfaces.

**Pairs with:**
- `content-series-phase` (often a campaign HAS a content series inside it)
- `outreach-phase` (campaigns often include outreach sequences)
- `landing-page-phase` (campaigns often need a campaign-specific landing page)
- `video-production-phase` (campaigns often need video assets)

## Anti-patterns

- DO NOT skip KPI definition. "Campaign without KPIs" → no way to know if it worked.
- DO NOT skip the post-campaign report. The retrospective is where future campaigns get sharper.
- DO NOT auto-pick all four channels (email + social + paid + organic) by default. Channel selection is a deliberate Plan 2 decision based on audience.
- DO NOT use campaign-phase for one-off content (single blog post, single email). That's `/doc` or `/draft` direct.
- DO NOT use campaign-phase for ongoing operations (weekly newsletter). That's content-series-phase.
