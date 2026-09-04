---
schema_version: 1.0
name: outreach-phase
display_name: Outreach Phase
category: marketing-and-ops
purpose: Multi-touch outbound communication. Four modes for cold email, LinkedIn outreach, warm follow-up, and nurture sequences. Voice-consistent and personalized at scale.
modes: [cold-email, linkedin, warm, nurture-sequence]
default_mode: cold-email
duration: medium
risk_level: medium
triggers:
  keywords: [outreach, cold email, cold outreach, LinkedIn outreach, follow-up sequence, nurture sequence, sales sequence, prospecting, drip campaign]
  patterns: ['(cold|warm)\s+(email|outreach|reach.out)', 'follow.up\s+(sequence|drip)', 'nurture\s+(sequence|campaign)', 'LinkedIn\s+(outreach|messages?)']
  file_signals: []
  required_after: []
  required_before: []
  recommended_for: [B2B sales, partnership development, recruiting, founder-led outreach, post-event follow-up]
recommended_skills: [draft, pipeline, contacts-update, prep, followup, humanizer]
related_paul_workflows: []
sources: [Caddy native, synthesizes draft + pipeline + contacts-update + prep + followup + humanizer skills into outreach workflow]
---

# Outreach Phase

## Purpose

Multi-touch outbound communication with personalization at scale. Four modes for the four most common outbound shapes:

- **`cold-email` mode**, net-new outreach to people who don't know you. Typical: 3-5 touch sequence with breaks.
- **`linkedin` mode**, LinkedIn-specific outreach (connection request → follow-up → DM sequence).
- **`warm` mode**, outreach to existing relationships (prior customers, past contacts, mutual connections).
- **`nurture-sequence` mode**, drip sequence for leads that have shown interest but not converted (usually email-based, scheduled over weeks).

All modes enforce voice consistency via humanizer and pipeline integration for tracking responses.

## When to recommend

### cold-email mode
- Selling to net-new prospects
- Building a sales pipeline from scratch
- Partnership development
- Recruiting

### linkedin mode
- B2B sales targeting decision-makers
- Founder-led outreach to mid-sized companies
- Recruiting active candidates

### warm mode
- Reactivating dormant customer relationships
- Post-event follow-up to people you met
- Reaching out to mutual connections

### nurture-sequence mode
- Lead has downloaded a resource but hasn't booked a call
- Lead has booked a call but ghosted
- Long sales cycles (B2B with 3-6 month decision windows)
- Newsletter sequence aimed at converting subscribers to customers

## Modes

### Mode: cold-email
3-5 touch cold email sequence. Per-prospect personalization (research → first message → follow-ups → exit). Pairs with pipeline tracking.

### Mode: linkedin
LinkedIn-specific cadence: connection request (with personalized note) → wait for accept → first DM → follow-up DMs over 2-4 weeks → exit.

### Mode: warm
Reactivation outreach. Lighter sequence (1-3 touches). Reference shared history. Lower friction ask.

### Mode: nurture-sequence
Drip sequence over weeks. Mix of value content (educational, free resources) and asks (book a call, try a demo). Slower cadence than cold/warm. Optimized for long sales cycles.

## Phase template (cold-email mode)

### Goal
Run a multi-touch cold email sequence to N prospects with personalization. Output: sent sequence, response tracking in pipeline, follow-up routing.

### Scope
- Define ICP (ideal customer profile) and target list
- Research per prospect (orchestrates `prep` skill)
- Sequence design (3-5 touches with timing)
- First message + follow-ups personalized per prospect
- Voice consistency via humanizer
- Send via Gmail draft (orchestrates `draft` skill)
- Track responses in pipeline
- Route warm responses to `close` skill / sales motion

### Plans (suggested decomposition)
- [ ] Plan 1: ICP definition + target list build
- [ ] Plan 2: Per-prospect research (orchestrates `prep` for each), capture relevant context
- [ ] Plan 3: Sequence design (touch 1 = X, touch 2 = Y, etc., with timing)
- [ ] Plan 4: Touch 1, personalized first messages per prospect (via `draft`)
- [ ] Plan 5: Touch 2-N, follow-ups per prospect
- [ ] Plan 6: Pipeline tracking, log every response in `pipeline`
- [ ] Plan 7: Warm responses → route to close motion
- [ ] Plan 8: Cold/no-response prospects → exit sequence

### Dependencies
- Voice fingerprint exists (humanizer setup complete)
- Gmail connected (for draft → send via `/setup`)
- Pipeline initialized (for response tracking)
- Contacts up to date (orchestrates `contacts-update`)

### Verification
- Target list defined and reviewed
- Sequence designed with explicit timing per touch
- Per-prospect personalization is genuine (not template-with-name-substitution)
- Voice consistency applied uniformly
- Pipeline reflects actual response status per prospect
- Warm responses have follow-up routing assigned

## Skills orchestrated

1. `draft`, Gmail draft composition with voice fingerprint
2. `pipeline`, response tracking + lead status
3. `contacts-update`, keep contact records current
4. `prep`, per-prospect research before outreach
5. `followup`, for warm-response routing post-call
6. `humanizer`, voice consistency layer

## Source notes

**Caddy native phase type, no external repo source.** Synthesized from the operator's installed Caddy skill catalog.

**Why all four modes in one phase type:** all four are multi-touch outbound communication. They differ in starting trust (cold/warm) and channel (email/LinkedIn) and cadence (single sequence/long drip), not in fundamental shape. Mode flag captures the variant.

**Caddy-specific design:**
- Voice consistency via humanizer is REQUIRED for all modes. Outreach in inconsistent voice reads as fake.
- Per-prospect personalization (not template-with-name) is REQUIRED. Outreach quality depends on research depth.
- Pipeline tracking is REQUIRED. Outreach without response tracking = no learning loop.
- Pairs naturally with `prep` skill which already has the per-attendee research pattern.

**Why no `mass-blast` mode:** Caddy's positioning is quality over quantity. Mass-blast outreach (no personalization, no research) is what Caddy explicitly steers customers AWAY from. If a customer wants mass-blast, they should use a different tool (Mailchimp, etc.) and Caddy doesn't compete.

**Pairs with:**
- `pipeline` skill for tracking
- `prep` skill for research
- `close` skill for warm-response handling
- `customer-lifecycle-phase` for what happens after a deal closes

## Anti-patterns

- DO NOT skip per-prospect research. Templated outreach with name-substitution is mass-blast in disguise.
- DO NOT skip voice consistency. Outreach that doesn't sound like the sender reads as fake.
- DO NOT skip pipeline tracking. Outreach without response tracking can't be improved.
- DO NOT use cold-email mode on warm contacts (insulting). Use warm mode.
- DO NOT use warm mode on net-new prospects (overstates relationship). Use cold-email mode.
- DO NOT design sequences with rapid touches. 24-hour follow-ups feel desperate; 3-5 day intervals respect prospect attention.
