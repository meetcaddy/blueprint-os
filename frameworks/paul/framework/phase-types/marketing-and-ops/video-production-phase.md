---
schema_version: 1.0
name: video-production-phase
display_name: Video Production Phase
category: marketing-and-ops
purpose: Video creation orchestrating the operator's installed video generation skill catalog and an optional UGC pack. Six modes intent-driven (ad / viral / brand / educational / testimonial / product), each maps to the right installed skill.
modes: [ad, viral, brand, educational, testimonial, product, vertical-specific]
default_mode: ad
duration: medium
risk_level: low
triggers:
  keywords: [video, ad, commercial, viral video, brand video, social hook, TikTok, Reels, Shorts, YouTube, video ad, product video, testimonial video, motion design, animation, CGI]
  patterns: ['(create|make|produce|generate)\s+(a|an|the)?\s*(video|ad|commercial|reel|short)', 'video\s+(ad|content|production|creation)']
  file_signals: []
  required_after: []
  required_before: []
  recommended_for: [post-Caddy-v3 marketing, VSL pipeline, social content, paid ads, product launches with video assets]
recommended_skills: [01-cinematic, 02-3d-cgi, 03-cartoon, 04-comic-to-video, 05-fight-scenes, 06-motion-design-ad, 07-ecommerce-ad, 08-anime-action, 09-product-360, 10-music-video, 11-social-hook, 12-brand-story, 13-fashion-lookbook, 14-food-beverage, 15-real-estate]
related_paul_workflows: []
sources: [Caddy native, orchestrates the operator's installed video generation skills and an optional UGC pack]
---

# Video Production Phase

## Purpose

Video creation orchestrated through the operator's installed video skill catalog. The phase asks "what's this video FOR?" (intent-driven mode) rather than asking the customer to memorize 15+ style skills. Per intent, the right skill(s) get invoked.

This phase exists because customers shouldn't need to know whether they want `06-motion-design-ad` or `07-ecommerce-ad` or `12-brand-story`. They know they want "an ad for my SaaS product" or "a viral hook for TikTok" or "a testimonial video." The phase handles the mapping.

## When to recommend

Auto-detection should recommend video-production-phase whenever:
- Customer asks for video creation
- Marketing campaign includes video assets
- Social content production
- Ad creative needed
- Product launch involves video
- VSL pipeline activates (post-Caddy-v3)

## Modes (intent-driven, mapped to installed skills)

### Mode: ad
Software/SaaS or e-commerce ads. Skill mapping:
- SaaS / software product → `06-motion-design-ad`
- Physical product e-commerce → `07-ecommerce-ad`

Output: video ad ready for paid media (Meta, TikTok ads, YouTube ads).

### Mode: viral
TikTok / Reels / YouTube Shorts hook content. Skill mapping:
- → `11-social-hook`

Output: scroll-stopping short-form video optimized for organic social.

### Mode: brand
Brand storytelling / company narrative. Skill mapping:
- Cinematic high-production → `01-cinematic`
- Founder / company story → `12-brand-story`

Output: brand film or about-us video.

### Mode: educational
Explainer / how-to / educational content. Skill mapping:
- Animated explainer (illustration-driven) → `04-comic-to-video`
- 3D / CGI explainer → `02-3d-cgi`
- Cartoon-style → `03-cartoon`

Output: explainer video for customer education or product demos.

### Mode: testimonial
Talking-head testimonial video. Skill mapping:
- → the UGC skill pack (dormant until activated). The phase recommends activation if it is not yet set up.

Output: UGC-style testimonial video.

### Mode: product
Product showcase / 360° view / hero shot. Skill mapping:
- 360° turntable → `09-product-360`
- E-commerce product ad → `07-ecommerce-ad`

Output: product video for landing pages or e-commerce listings.

### Mode: vertical-specific
Vertical-specific content. Skill mapping:
- Fashion → `13-fashion-lookbook`
- Food & beverage → `14-food-beverage`
- Real estate / architecture → `15-real-estate`
- Music video / lyric video → `10-music-video`
- Anime style → `08-anime-action`
- Fight / action scenes → `05-fight-scenes`

Output: vertical-flavored video matched to customer's industry.

## Phase template

### Goal
Produce a video matching the intent + brand. Output: video file + metadata (mode used, skill invoked, duration, format).

### Scope
- Identify intent (which mode)
- Confirm skill activation (the video generation connector active; the UGC pack activated if testimonial mode)
- Generate prompt(s) for the chosen skill
- Execute video generation
- Review output
- Iterate if needed
- Save to project / deliver to customer

### Plans (suggested decomposition)
- [ ] Plan 1: Intent classification (which mode + which skill)
- [ ] Plan 2: Connector check (video connector active? UGC pack activation needed?)
- [ ] Plan 3: Brief, what the video needs to communicate
- [ ] Plan 4: Generate via chosen skill
- [ ] Plan 5: Review + iterate (max 2 regenerations)
- [ ] Plan 6: Save + deliver

### Dependencies
- The video generation connector active among the operator's installed connectors
- For testimonial mode: the UGC pack activated (its own setup script run)
- Brand kit exists (visual + tone consistency)

### Verification
- Video generated and saved
- Output matches intent (smoke check)
- Brand consistency applied (visual style + voice tone match brand kit)
- Customer review captured (for client work)

## Skills orchestrated

The operator's installed video generation skills (style skills such as cinematic, product, real estate). Plus an optional UGC skill pack, activated on demand.

Plus supporting Caddy skills:
- `brand-kit`, visual + tone consistency
- `humanizer`, script copy if video has voiceover or text overlays

## Source notes

**Caddy native phase type, no external repo source.** Orchestrates the operator's installed video skill catalog into an intent-driven workflow.

**Why intent-driven mode flags instead of style-driven:** An operator may have 15 or more style skills. If video-production-phase had 15+ modes, it would be skill-catalog mirror with no value-add. Intent-driven mode + skill mapping table is the value-add: customer thinks "viral video" not "11-social-hook"; phase handles the translation.

**Why no `talking-head` skill in default catalog:** A UGC pack handles this but is dormant. Activation is on demand (a deliberate default). Phase recommends activation when testimonial mode triggers.

**Pairs with:**
- `campaign-phase` (campaigns often need video assets)
- `content-series-phase` (video series modes)
- `landing-page-phase` (landing pages often have video heroes)
- `outreach-phase` (video can be used in outreach DMs / cold emails)

**Future consideration:** post-launch VSL pipeline (per `project_caddy_vsl_pipeline_scope.md` memory) will likely add a `vsl` mode here. Bookmark for v3.5 when VSL pipeline starts.

## Anti-patterns

- DO NOT pick mode by skill name. Mode is intent ("what's the video FOR"); skill is the tool. Customer-facing language is intent.
- DO NOT generate video without a brief. Plan 3 (brief) is non-skippable; without it, generation produces generic output.
- DO NOT regenerate more than 2 times without reconsidering the brief. If output is wrong twice, the brief is the problem, not the model.
- DO NOT use this phase for video EDITING (cutting existing footage). Caddy's video catalog is GENERATION-focused.
- DO NOT skip brand-kit reference. Video without brand consistency dilutes the customer's brand.
