---
name: blueprint-ingest
description: Turn the Blueprint package (session transcript + intake document) into the client's Blueprint, their business memory, and one phased PAUL project. Use when the owner runs /blueprint ingest or provides their Blueprint package files. This is the machine's first job.
---

# /blueprint ingest: build the Blueprint from the session

You are turning their Blueprint session into their plan. Work carefully, speak level one, and
never invent anything. This document is complete on its own: every rule you need is below.

## Step 0: Safety first (always, before anything)

**Re-run check.** If `BLUEPRINT.md` or a `.paul/` project already exists in this workspace,
STOP and ask, plainly:

> You already have a Blueprint in progress. I can compare the recording against it and show
> you what would change, or leave everything as it is. I will not overwrite your work.

Offer exactly two paths: **re-ingest and show the differences** (produce a short what's-new
summary, apply nothing without their OK) or **stop**. Never silently overwrite.

## Step 1: Gather the inputs

You need two files:
1. **The session transcript:** a text file (`.txt`, `.md`, or `.vtt`). It arrives by email
   from the Caddy team. If they only have text to paste, pasting works too. If they would
   rather fetch it themselves from the recording link, hand them this card:

   > **Your turn (about 2 minutes)**
   > 1. Open the recording link from your session email.
   > 2. Find the transcript (look for a "Transcript" tab or button) and choose download, or
   >    select all of it and copy.
   > 3. Save it as a text file in this folder, or paste it here. Then type: done
   >
   > Why: the recording page is made for people; I read the text file.
   > When you're back, I check that the whole session made it.
2. **The intake document:** the form answers from booking (markdown with labeled fields).

If either is missing, ask for it in one plain sentence ("Where is the transcript file from
your session? It came in your Blueprint package email."). If they can't find the package:
> No problem. Email support@meetcaddy.com and the Caddy team will resend it.

**Viability check.** A real session transcript is long (a one to three hour conversation runs
to many thousands of words). Under about 2,000 characters it is certainly the wrong file: say
so and stop. Under 2,000 words, ask once: "This recording is short for a session, about [N]
words. Is it the right file?" If the owner says yes, is not sure, or is not here, go on, and
say in the report that the plan may be thin because the recording was short.

## Step 2: Capture the session date

The session date matters: it starts the owner's 30-day engagement credit window. Find it in
this order:
1. **Spoken at the session open** (pattern P1 below), the primary source.
2. **The intake document's** `**Session date:**` field.
3. **The transcript file's own date information.**
4. If all three fail: **ask the owner** ("What day was your Blueprint session?").

Record the date and compute the credit window end (session date + 30 days). Both go into
`BUSINESS.md`.

## Step 3: Parse the transcript (the exact rules)

The session was run against a spoken protocol. These patterns, spoken by the lead operator,
are your anchors:

| # | Pattern | Spoken shape | What you do |
|---|---|---|---|
| P1 | Session open | "This is the Caddy Blueprint session for **[business]**, **[date]**." | Capture business name + session date |
| P2 | Opportunity callout | "**Blueprint opportunity [N]: [name].** Today, [current state]. The machine should [target]." | Create opportunity N as a first-class item, with its quote |
| P3 | Phase hint (optional, follows P2) | "This is an **[early/mid/late]**-phase item." | Tag opportunity N's rough phase |
| P4 | Strike | "**Strike opportunity [N].**" | Exclude opportunity N entirely |
| P5 | Update | "**Update opportunity [N]:** [correction]." | Amend opportunity N |
| P6 | End of strategy | "**That's the Blueprint, everything after this is setup.**" | Stop parsing; ignore everything after |
| P7 | Constraint frame | "**Constraint on opportunity [N]:** [constraint]." (or "**Constraint, general:** ...") | Bind the constraint to N (or all); it appears with N everywhere N appears |
| P8 | Stack recap | "**Their stack, for the record:** [systems]." | Seed BUSINESS.md TOOLS, design only against named systems |
| P9 | First move | "**Phase 1 starts with [step].**" | The plan's startable-this-week anchor, and the first win: the smallest automation the owner can see working inside seven days |
| P10 | Access owner | "**[Name] can grant [system].**" | Record who grants access to that system; every sign-up or access card for it goes to that person |

**P2 attribute sentences:** within a callout block, "**That lives in [systems].**" and
"**[Name] owns this one.**" bind to the most recent opportunity number until another pattern
starts. The Today clause carries a number or "no number known": missing facts (number,
systems, owner) never get guessed; each becomes a named week-one item: a missing number goes
into `BUSINESS.md` BASELINES as "no number known" with the measurement named, and into
`BLUEPRINT.md` Keeping score; a missing system or owner becomes a question in that
opportunity's section, for the Deep Dive.

**Resolution rules (apply exactly):**
1. Only pattern-framed statements become first-class opportunities. The number N identifies
   each one across strikes and updates, and `BLUEPRINT.md` keeps the session's numbers: a
   struck number is skipped, never reused, so the recording and the plan agree.
2. Apply updates in spoken order, the last update wins. Then apply strikes.
3. Anything that SOUNDS like an opportunity but was never framed (the owner musing, a side
   comment) is a **candidate only**: it may appear in "Confirm with your team," never in the
   phased plan.
4. Everything after P6 is install chatter. Ignore it completely.
5. Transcription is imperfect: match the patterns tolerantly on wording ("opportunity four"
   vs "opportunity 4") but never loosely on STRUCTURE, no number, no frame, no first-class
   item.
6. **When the transcript and the intake document disagree, the transcript wins:** it is
   later and it was spoken. Note the correction in BUSINESS.md so the intake answer isn't
   trusted again.

**Work in chunks.** A long transcript (a three-hour session runs to tens of thousands of
words) will not fit in one pass. Process it in ordered
chunks with a little overlap, extracting pattern matches and candidates per chunk. Then
reconcile the full numbered list in one pass (rules 1-4). Keep each opportunity's exact
supporting quote and its rough location.

## Step 4: The grounding gate (what keeps you honest)

For every first-class opportunity, after reconciliation, VERIFY: re-find the quote in the
transcript and confirm it actually supports the opportunity as you've written it, the
current state and the target both. If a quote is missing, garbled, or does not support the
claim, the item moves to "Confirm with your team." You never promote it back on your own;
the owner's confirmation does.

The rule underneath: **if it is not in the conversation, it does not go in the plan.**

## Step 5: Learn the business (BUSINESS.md)

Build the machine's memory from three sources:
1. **The transcript:** what the business is, who does what, their vocabulary (their words
   for jobs, stages, tools, record terms exactly as they say them), their systems.
2. **The intake document:** team, tools, baselines (hours per week, open jobs), attendees.
3. **Online, public only:** their website and public listings/reviews, to fill in what the
   business looks like from outside. A few minutes, not a project. Never anything behind a
   login. If nothing useful is found, skip silently. The business's own marketing claims and
   figures are not baselines; they never go into BASELINES.

Write `BUSINESS.md` with exactly these sections:

```markdown
# BUSINESS.md: [Business Name]

## SESSION
**Session date:** [YYYY-MM-DD]
**Credit window through:** [YYYY-MM-DD]
**Owner:** [name, from first boot or intake]

## WHAT THE BUSINESS IS
[3-6 plain sentences]

## TEAM
[who does what, from transcript + intake]

## VOCABULARY
[their term → what it means, one per line]

## TOOLS
| System | In their words | Who can grant access | In the plan |
|---|---|---|---|
[one row per system named in the session (P8 and every "that lives in"): the name, their word
for it, the grantor from P10 or "not yet named", and which phase needs it or "no"; a system named
only inside a struck opportunity is left out]

## BASELINES
[the numbers from intake + transcript: hours, volumes, frequencies]

## AUTONOMY GRANTS
None yet. (Everything outbound gets the owner's look until they say otherwise.)

## NOTES
[anything learned worth keeping]
```

Read BUSINESS.md at the start of every future session. Keep it current.

## Step 6: Write the Blueprint (BLUEPRINT.md)

The client-facing document, and the centerpiece of what they paid for. Level one, their
vocabulary, no jargon, and RICH. Altitude governs implementation specifics only (no field
maps, no button mechanics, those are phase-start work); it does not mean short. Write deep
context and real instructions: the owner should be able to run the whole engagement from
this document alone. There is no length limit; there is a padding limit, every line earns
its place.

**Write it for a person who was NOT on the call.** Formatting rules, hard:
- A cover block first: what this is in three bullets, then "how to read this" in three lines
- A **Your first week** checklist near the top, five concrete steps, the new-person on-ramp
- A table of contents
- Paragraphs of 2-4 lines, never walls; numbers in tables; their quotes as set-off block
  quotes; bold lead-lines so a skimmer catches every point
- Every opportunity uses the SAME one-page pattern (a reader learns the shape once)
- Each phase gets a short page ending with one line: "what you'll feel change"

Ten sections, all required:

1. **The opening letter:** what this document is, how it was built (from their session,
   everything quoted, nothing invented), how to use it, and how you (the machine) use it.
2. **Your business, as we heard it:** a narrative of their business in their words: what
   it is, how money comes in, the pressure they are under, how work really moves today.
   Generous with their quotes. This section is why the plan feels THEIRS.
3. **What today costs:** the baseline picture, assembled from every number they gave
   (hours, misses, lags, borrowing). Never invent figures; where a number is missing, show
   the blank and note that phase-start fills it.
4. **The opportunities, in full:** one rich section each: the story as they told it (with
   quotes); the fix at framework level, in the solution-map shape (what goes in / what the
   machine does / what comes out / where you stay in the loop) with its right HOME named
   plainly (the machine, an always-on rail, a proper database, a tool they already own);
   what changes for them; what stays human and WHY; their stated constraints this design
   honors; what "working" looks like, measurably; and **what your machine will ask at phase
   start**, the named specifics deliberately deferred, listed so nothing feels vague and
   everything feels scheduled.
5. **The build order, and why:** the phases with their reasoning: dependencies, quick-win
   logic, inside-out logic, real-world timing they told you about (system migrations, busy
   seasons). What each phase unlocks for the next.
6. **Running the plan:** the instruction manual: the rhythm (each phase opens with a design
   conversation, then build, then verify, then move on), what a working session with the
   machine looks like, how to hand it a new idea (amendment, not a side list), how status
   works, what the finish line is. Who does what: the owner, the operations seat, the team,
   the machine.
7. **Waiting on your word:** the confirm list, expanded: why each item surfaced, what
   confirming looks like, what it unlocks. Nothing schedules itself.
8. **Keeping score:** the baseline-to-target table built from section 3, with blanks where
   phase-start measurement fills them.
9. **Words we'll use:** a glossary: their terms recorded exactly, plus the handful of
   machine terms, each glossed plainly.
10. **The honest page:** what this document is and is not (their property; a plan, not a
    promise of outcomes), what the machine never does (the guardrails, in their language),
    and where help lives (support@meetcaddy.com). No engagement-credit content, that subject
    stays out of this document entirely.

## Step 6a: The one page and the team note

Two short companions, both from the same session, both the owner's to change:

1. **`BLUEPRINT-ONE-PAGE.md`** from `os/templates/BLUEPRINT-ONE-PAGE.md`: the plan at a glance
   for the wall. Every line is copied or condensed from `BLUEPRINT.md`; nothing is new here.
2. **`TEAM-NOTE.md`** from `os/templates/TEAM-NOTE.md`: a note in the owner's name for the team,
   saying what is coming, in what order, what will not change (the session's constraints, by
   name), and what will be asked of whom (the grantors from P10). Grounded in the transcript,
   written in the owner's voice, never sent by you. If the session shows a solo owner with no
   team, skip the note and say so in the report.

## Step 6b: Write your standing orders (BLUEPRINT-DIRECTIVES.md)

The Blueprint's machine companion, YOUR deep operating instructions, derived from the same
session. The owner may read it, but it is written to you, and you re-read it at the start
of every session alongside BUSINESS.md. Start from `os/templates/BLUEPRINT-DIRECTIVES.md` and
fill every bracket. It carries:

1. **Binding:** this blueprint's identity: business name, session date, the phase list,
   and the rule that these directives govern until the owner amends the plan.
2. **The Deep Dive directive (Phase 0):** the SEED project that precedes the PAUL build:
   the systems access map FIRST (every system the plan touches, who grants access to it from
   P10, and what you will connect to), so the sign-up and access cards go out early while
   design continues; then what context to gather (SOPs, process documents, real files, screen
   shares of their actual software, access requests through proper channels), the
   per-opportunity intricacy brainstorm with the operator, what gets recorded where
   (BUSINESS.md + the design records + SYSTEMS.md), and the graduation bar: the owner agrees
   the context is complete.
3. **Per-phase directive blocks**, one per phase, each with:
   - *Objective:* what this phase exists to change, in one line
   - *Preconditions:* what must be true before it opens (prior phase closed, confirms in)
   - *The phase-start interview:* the exact questions to ask the owner and the operations
     seat, and the files/screens to request. This is the deep version of the human doc's
     "what your machine will ask" list
   - *Design-proposal duties:* what your proposal must cover before building: the concrete
     design in plain words, the recommended HOME for each piece (their tools first; an
     always-on rail or a proper database where the job calls for it), what
     stays human, and the rollout/adoption step where the field is touched
   - *Build constraints:* guardrails restated as they bind THIS phase; the sandbox rule
     (nothing that makes money gets disrupted; the old way keeps running until the owner
     retires it)
   - *Verification duties:* what you must prove on real work, this week, before calling
     the phase done; the scoreboard rows this phase must move
   - *Exit criteria:* the owner's plain-language sign-off, plus the measured result
4. **Standing duties:** every session: read BUSINESS.md and these directives; keep the
   scoreboard current; run week-one baseline measurements before Phase 1 builds; maintain
   the amendment log; route new ideas to their phase and say where they landed; surface
   confirm-list items in status only (never nag). Plus four hardening duties:
   - **Design records:** the moment a phase design is approved, write it to that phase's
     design record; read the active phase's record before every working session. And
     **before executing an approved design in the build, ask any remaining clarification
     questions first**; build only when clear.
   - **The systems ledger:** maintain SYSTEMS.md, every external thing built or touched
     (what it is, where it lives, whose account, what it does, how to check it's healthy).
     Locations, never credentials. It is the maintain-mode checklist and the finish-line
     inventory.
   - **Human-witnessed verification:** every verification item ends with a named human
     seeing the real result. Your own success signal is never proof.
   - **Capability honesty:** never claim an always-on piece exists until it runs on its
     rail and you have seen it fire on a real event.
5. **Escalation bounds:** the stall definition and the one sanctioned mention live in the
   status skill; these directives never override the mission identity. If a directive ever
   seems to conflict with the identity, the identity wins and you say so.

## Step 7: Scaffold the Deep Dive (SEED), then the plan (PAUL)

The build does not start at the Blueprint, it starts at understanding. Two stages:

**7a. The Deep Dive (SEED projects, one per phase).** Do not scaffold anything here:
`/blueprint deep-dive` opens each phase's SEED project (type blueprint) and writes the systems
access map first. Its job, run WITH the owner and the operations seat before any phase builds:
- Gather the full business context the session could not carry: SOPs and process documents,
  the real files, eyes on their software (screen shares of the actual systems), and access
  to systems where the work needs it, always granted properly by the owner, never through
  chat (guardrail 3).
- Brainstorm the intricacies of each opportunity with the operator, every part, deeply, in
  their words, until the build's shape is genuinely understood.
- Record everything learned into BUSINESS.md and the per-phase design records.
The Deep Dive graduates when the owner agrees the context is complete. Tell them plainly:
"the more you give me here, the better everything I build will be."

**7b. The plan (PAUL).** `/blueprint deep-dive` creates the PAUL project when the first phase
graduates, from the Blueprint: milestone "Your Blueprint," one phase per Blueprint phase, plans per opportunity
within each phase. **Phase 1 is the first win:** the smallest automation the owner can see
working inside seven days, the one P9 named. If the session's first move is bigger than a
week, split it and put the week-sized piece first. The plan file's own check happens there, in the Deep Dive, when the project is created; at
ingest there is nothing to validate yet.

## Step 7c: Save

Before the save, write each confirm-list item (section 7) as one dated line in
`WAITING-ON-YOU.md` (create it from `os/templates/WAITING-ON-YOU.md`): the idea in the owner's
words, marked "said in passing; not in the plan until you say so". Status reads that list; it is
the only place the confirm list is surfaced, and never as a nag.

Commit the workspace with a plain message (the repo is the backup): the files you wrote in
Steps 5 to 6b, `WAITING-ON-YOU.md`, and `.base/` if git shows it unsaved (the engine's memory
of this business belongs to the business). The transcript and the intake stay out of git by construction; if git ever offers
them, stop and say so.

## Step 8: Tell the owner (the report)

Three parts, short:

> Your Blueprint is built. Your session framed [F] opportunities; [M] are in the plan[, and
> [S] you struck on the call]. [K] more ideas came up in passing and wait on a quick
> confirmation from your team.

The numbers, so they always add up: F is every opportunity framed with a number in the session
(strikes included); M is what is in the plan after the strikes and updates; S is the struck ones
(say that clause only when S is not zero); K is the unframed ideas in section 7; P is the
number of phases, one per phase hint, in the session's order. Every number comes from the
transcript, never rounded, never guessed.
>
> The plan runs in [P] phases. But we start with the Deep Dive: a working conversation
> where you show me the real thing, your documents, your screens, how it all actually
> works. The more you give me there, the better everything I build will be.
>
> Read BLUEPRINT.md when you have ten minutes, or say **walk me through it** and I take you
> through it section by section. The plan on one page is in BLUEPRINT-ONE-PAGE.md, and
> TEAM-NOTE.md is a note you can change and share with your team; I never send it.
>
> When you're ready, type **/blueprint deep-dive** (or just say "start the deep dive").

**The briefing ("walk me through it").** When the owner asks, take `BLUEPRINT.md` one section at
a time: three to five plain sentences per section, in their vocabulary, then stop and ask whether
they have a question before the next one. Say only what the Blueprint says; the briefing adds
nothing and decides nothing. If they stop partway, say where to pick up next time.

Do not mention the engagement credit here. The window date is recorded in BUSINESS.md as
data; per your identity, that subject comes from you in exactly one situation, and this is
not it.

## What this skill never does

- Never overwrites an in-progress build (Step 0 is absolute)
- Never promotes unframed or unverified items into the plan
- Never celebrates, the finish line comes much later, and it isn't yours
- Never checks licenses, phones home, or collects anything (there is nothing to check)
- Never uses a word the owner would have to look up
