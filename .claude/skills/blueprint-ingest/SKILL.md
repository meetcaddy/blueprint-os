---
name: blueprint-ingest
description: Turn the Blueprint package (session transcript + intake document, plus the Caddy team's roadmap brief when one was sent) into the client's Blueprint, their business memory, and one phased PAUL project. Use when the owner runs /blueprint ingest or provides their Blueprint package files. This is the machine's first job.
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

First, run `python3 os/bin/package-check.py` from this folder. It says what is in `package/`:
the transcript, the intake document, and the Caddy team's roadmap brief when one was sent. It
reads the brief's shape, lists the opportunities each source carries, and names every place
the brief and the transcript disagree. When it prints a line that starts with **Stop:**, say
that line to the owner in plain words and stop: the transcript or the intake is missing. A
brief with no transcript is one of those stops: the brief alone is never enough, the plan is
built from the session. Keep its other lines; Steps 3, 4 and 8 use them.

You need two files, and there may be a third:
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
2. **The intake document:** the client's answers as markdown with labeled fields: the five
   booking headings always, and, when the client filled in their Audit Workbook after paying,
   its sections too (systems, team, money and volume, workflows, samples, customers and
   communication, constraints, goals, gaps). An older document with the five headings alone is
   complete; nothing is missing then. Step 1b says what each Workbook section becomes.
3. **The roadmap brief (optional):** `package/roadmap-brief.md`, written by the Caddy team
   after the session, for you. Its shape is in Step 1a. When it is not there, nothing is
   missing: the team sends one with some packages, not all. Never ask the owner for it.

If the transcript or the intake is missing, ask for it in one plain sentence ("Where is the
transcript file from your session? It came in your Blueprint package email."). If they can't find the package:
> No problem. Email support@meetcaddy.com and the Caddy team will resend it.

**Viability check.** A real session transcript is long (a one to three hour conversation runs
to many thousands of words). Under about 2,000 characters it is certainly the wrong file: say
so and stop. Under 2,000 words, ask once: "This recording is short for a session, about [N]
words. Is it the right file?" If the owner says yes, is not sure, or is not here, go on, and
say in the report that the plan may be thin because the recording was short.

## Step 1a: The roadmap brief (when the Caddy team sent one)

The brief is the Caddy team's notes for you, written from the session and from what the team
checked afterwards (each system's plan and version, on a named date). It speaks in the
session's own shapes, so the rules in Step 3 read it the way they read the transcript. Its
shape is `os/templates/roadmap-brief.md`; the check script sets aside a brief that breaks the
shape and says why, and then you build from the transcript and the intake alone and say so in
the report.

What it carries, in order:
- **The header:** the business, the session date, the author (always the Caddy team) and the
  date it was written.
- **Their stack, for the record:** one row per system with the team's verdict: *connect* (you
  design against it and connect to it), *replace* (the plan builds its replacement; you never
  connect to it) or *work around* (you work beside it, no connector), with the plan and version
  the team saw and the date checked.
- **The opportunities:** each in the P2 shape with its five facts (the number, Today with a
  number or "no number known", what the machine should do, where it lives, who owns it), its
  phase hint and any constraint on it.
- **Constraints, general:** what binds the whole plan.
- **Phase 1 starts with:** the first move.
- **Access owners:** who can grant each system.
- **Unconfirmed:** what the team heard but could not ground. These never enter the plan: they go
  to "Confirm with your team" (Step 6, section 7) and to `WAITING-ON-YOU.md`, marked "from the
  Caddy team's notes; not in the plan until you say so".

Four rules, absolute:
1. **The brief is a second grounded source.** An opportunity that is in the brief and not in
   the transcript enters the plan with the brief as its citation ("from the Caddy team's
   notes, opportunity N"). In `BLUEPRINT.md` such an item says so in one plain line, "The
   Caddy team added this one after your session, from what we heard and checked", and quotes
   the brief's block where a session item quotes the owner.
2. **The transcript wins every disagreement.** The same number means the same opportunity in
   both sources. When the name, the target, a system, an owner, a phase hint or a constraint
   differ, keep the transcript's version, say so in the report (one line per disagreement),
   and write the correction in `BUSINESS.md` NOTES so the brief's version is not trusted
   again. A strike in the transcript beats the brief: that number stays out. The brief carries
   no strikes and no updates of its own.
3. **A brief with no transcript is not enough.** The transcript stays mandatory; Step 1 stops
   there. You never build from the brief alone, and never from the brief and the intake
   without the session.
4. **The report counts what came from each source.** Step 8 defines the numbers.

The stack verdicts go into `BUSINESS.md` TOOLS (Step 5) and into the Blueprint's picture of
their systems (Step 6, section 2); a *replace* verdict shapes the design, so the directives
(Step 6b) carry it as a build constraint. To the owner the brief is "the Caddy team's notes":
a plain name for a file they never have to open. The brief stays out of git by construction,
like the transcript; if git ever offers it, stop and say so.

## Step 1b: The Audit Workbook (when the intake document carries it)

Run `python3 os/bin/intake-read.py`. It reads `package/intake-doc.md` and prints plain blocks
you copy in Steps 3 to 7c; it writes nothing. When the document carries the booking answers
alone it says so and prints nothing more: go on, nothing is missing. To the owner the Workbook
is "your Audit Workbook", the form they filled in after they paid.

What each section becomes:
- **SYSTEMS seeds the systems ledger.** Create `SYSTEMS.md` from `os/templates/SYSTEMS.md` and
  paste the rows the script prints, one per system, each with "not connected yet" in its check
  cell. These are systems the business runs, not things you built: status, the Monday brief and
  `/blueprint health` count them apart from what is connected, and a row changes only when you
  connect to that system (it gets its check then) or the plan replaces it. A system the Workbook
  lists and the session never named is still not designed against (Step 3, P8): it waits in the
  ledger until the session or the Deep Dive brings it into the plan.
- **TEAM, MONEY AND VOLUME, CUSTOMERS AND COMMUNICATION, CONSTRAINTS and GOALS land in
  `BUSINESS.md`** (Step 5), pasted as the script's "Business memory" block prints them: the
  field headcount, the office roles with their headcounts and what they spend most time on, the
  champion and the office payroll range in TEAM; the money and volume lines and the leads a week
  in BASELINES ("not tracked" stays "not tracked" and is a week-one measurement, never a guess);
  the other three in their own sections. The directives (Step 6b) carry the constraints as build
  constraints where they touch a phase.
- **WORKFLOWS are grounding-gate candidates beside the transcript, never opportunities on their
  own.** A workflow the client wrote up (its name, its recording, its steps) that describes an
  opportunity the session framed adds detail to that opportunity's section, quoted as "what you
  showed us in your Audit Workbook". A workflow the session never framed goes to "Confirm with
  your team" (Step 6, section 7) and to `WAITING-ON-YOU.md`, marked "from your Audit Workbook;
  not in the plan until you say so". The session's numbered list never changes because of a
  Workbook workflow.
- **SAMPLES** are files the client sent the Caddy team, not files on this computer. Record their
  names in `BUSINESS.md` NOTES, as the block prints them; the Deep Dive asks for copies into
  `context/` first.
- **GAPS go on the short list.** Each gap the client left (what is missing and what it feeds) is
  one dated row in `WAITING-ON-YOU.md` with "your Audit Workbook" as where it came from, so the
  owner can clear them in one sitting. Status reads that list.

The transcript still wins every disagreement with the intake document (Step 3, rule 6).

## Step 2: Capture the session date

The session date matters: it starts the owner's 30-day engagement credit window. Find it in
this order:
1. **Spoken at the session open** (pattern P1 below), the primary source.
2. **The roadmap brief's** `**Session date:**` line, when the brief is there.
3. **The intake document's** `**Session date:**` field.
4. **The transcript file's own date information.**
5. If all four fail: **ask the owner** ("What day was your Blueprint session?").

Record the date and compute the credit window end (session date + 30 days). Both go into
`BUSINESS.md`.

## Step 3: Parse the transcript, and the brief (the exact rules)

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
7. **The brief is read with the same patterns, in writing:** its opportunity headings are P2
   callouts with the five facts under them, its stack table is P8 with a verdict per row, its
   constraints are P7, its first move is P9, its access owners are P10. Its numbers are the
   session's numbers. Reconcile both sources into ONE numbered list: the transcript's items
   first, in the transcript's words, after its updates and strikes; then the brief's items
   the transcript does not carry, cited to the brief. The check script's "In both", "From
   the brief only" and "Disagreement" lines are your starting list; the grounding gate
   (Step 4) decides what stays.
8. **A Workbook workflow is read beside the transcript, never as a pattern.** It carries no
   number and no frame, so it is never first-class on its own: match it to a framed opportunity
   by what it describes and quote it there, or treat it as a candidate (rule 3).

**Work in chunks.** A long transcript (a three-hour session runs to tens of thousands of
words) will not fit in one pass. Process it in ordered
chunks with a little overlap, extracting pattern matches and candidates per chunk. Then
reconcile the full numbered list in one pass (rules 1-4 and 7). Keep each opportunity's exact
supporting quote and its rough location.

## Step 4: The grounding gate (what keeps you honest)

For every first-class opportunity, after reconciliation, VERIFY: re-find the quote in its
source and confirm it actually supports the opportunity as you've written it, the current
state and the target both. For a session item the source is the transcript; for a brief item
it is the brief's own block, which must carry the five facts. If a quote is missing, garbled,
or does not support the claim, the item moves to "Confirm with your team." You never promote
it back on your own; the owner's confirmation does. The brief's "Unconfirmed" list starts in
"Confirm with your team" and never leaves it on its own. A Workbook workflow is the same: it
grounds detail inside an opportunity the session framed, or waits in "Confirm with your team";
it never grounds a new one.

The rule underneath: **if it is not in the conversation or the Caddy team's brief, it does
not go in the plan.** And when the two disagree, the conversation decides.

## Step 5: Learn the business (BUSINESS.md)

Build the machine's memory from three sources:
1. **The transcript:** what the business is, who does what, their vocabulary (their words
   for jobs, stages, tools, record terms exactly as they say them), their systems.
2. **The intake document:** team, tools, baselines (hours per week, open jobs), attendees;
   and, when the Audit Workbook is there, everything Step 1b routes here, pasted as the
   script's "Business memory" block prints it.
3. **Online, public only:** their website and public listings/reviews, to fill in what the
   business looks like from outside. A few minutes, not a project. Never anything behind a
   login. If nothing useful is found, skip silently. The business's own marketing claims and
   figures are not baselines; they never go into BASELINES.

When the roadmap brief is there, it adds the Caddy team's verdict per system (connect, replace
or work around, with the plan and version the team saw and the date checked) and its access
owners. Nothing else from it goes into BASELINES: the brief's numbers are the session's
numbers, already in the transcript and the intake.

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
[who does what, from transcript + intake; when the Workbook is there: people in the field, the
office roles with headcounts and what they spend most time on, the champion, the office payroll
range]

## VOCABULARY
[their term → what it means, one per line]

## TOOLS
| System | In their words | Who can grant access | What the Caddy team found | In the plan |
|---|---|---|---|---|
[one row per system named in the session (P8 and every "that lives in") or in the brief's
stack table: the name, their word for it, the grantor from P10 or from the brief or "not yet
named", the brief's verdict ("connect", "replace" or "work around", with the plan, the version
and the date checked; "not checked" when there is no brief), and which phase needs it or "no";
a system named only inside a struck opportunity is left out]

## BASELINES
[the numbers from intake + transcript: hours, volumes, frequencies; the Workbook's revenue band,
gross margin band, average job size, jobs a month, days to get paid, overtime hours a month and
leads a week; "not tracked" stays "not tracked", a week-one measurement]

## CUSTOMERS AND COMMUNICATION
[from the Workbook: lead sources, who answers first, leads a week, channels, what is sent and
when; "Not in your package." when the intake document does not carry it]

## CONSTRAINTS
[from the Workbook: the flags and the details; "Not in your package." when absent. The session's
constraints (P7) live with their opportunities, not here]

## GOALS
[from the Workbook: the 12-month goal, the exit horizon, who signs off on a build, what done
looks like; "Not in your package." when absent]

## AUTONOMY GRANTS
None yet. (Everything outbound gets the owner's look until they say otherwise.)

## NOTES
[anything learned worth keeping; every place the brief and the session disagreed, with the
session's version kept; the samples the client sent with their Workbook, by name, and the ones
marked not available]
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

1. **The opening letter:** what this document is, how it was built (from their session, and
   from the Caddy team's notes when they sent some; everything quoted, nothing invented), how
   to use it, and how you (the machine) use it.
2. **Your business, as we heard it:** a narrative of their business in their words: what
   it is, how money comes in, the pressure they are under, how work really moves today.
   Generous with their quotes, and with what they wrote in their Audit Workbook (their team,
   their numbers, their goals), quoted the same way. This section is why the plan feels
   THEIRS. When the brief carries verdicts, close with a short table, "Your systems, as the Caddy team checked them on
   [date]": each system, and in plain words whether it stays and gets connected, gets replaced,
   or gets worked around.
3. **What today costs:** the baseline picture, assembled from every number they gave
   (hours, misses, lags, borrowing; the Workbook's money and volume lines included). Never
   invent figures; where a number is missing, show the blank and note that phase-start fills it.
4. **The opportunities, in full:** one rich section each: the story as they told it (with
   quotes); the fix at framework level, in the solution-map shape (what goes in / what the
   machine does / what comes out / where you stay in the loop) with its right HOME named
   plainly (the machine, an always-on rail, a proper database, a tool they already own);
   what changes for them; what stays human and WHY; their stated constraints this design
   honors (the session's, and the Workbook's where they touch it); what you showed us in your
   Audit Workbook, where a Workbook workflow describes this opportunity (its steps or its
   recording, quoted); what "working" looks like, measurably; and **what your machine will ask
   at phase start**, the named specifics deliberately deferred, listed so nothing feels vague and
   everything feels scheduled. Each opportunity names its source in one line: "From your
   session", or "The Caddy team added this one after your session, from what we heard and
   checked" with the brief's block quoted; when the session and the notes disagreed about it,
   one more line says what the session said and that it was kept.
5. **The build order, and why:** the phases with their reasoning: dependencies, quick-win
   logic, inside-out logic, real-world timing they told you about (system migrations, busy
   seasons). What each phase unlocks for the next.
6. **Running the plan:** the instruction manual: the rhythm (each phase opens with a design
   conversation, then build, then verify, then move on), what a working session with the
   machine looks like, how to hand it a new idea (amendment, not a side list), how status
   works, what the finish line is. Who does what: the owner, the operations seat, the team,
   the machine.
7. **Waiting on your word:** the confirm list, expanded: why each item surfaced, what
   confirming looks like, what it unlocks. Nothing schedules itself. The brief's unconfirmed
   items sit here too, marked as the Caddy team's, and so do the Workbook workflows the session
   never framed, marked as the owner's own write-up.
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
     retires it); and the brief's verdicts where they touch this phase: a system marked
     replace is never connected to and its replacement is designed at phase start, a system
     marked work around gets no connector; and the Workbook's constraints (`BUSINESS.md`
     CONSTRAINTS) where they touch this phase, by name
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
words, marked "said in passing; not in the plan until you say so". Then the Workbook's gaps, one
row each, as the script's "Waiting on you" block prints them (Step 1b). Status reads that list;
it is the only place the confirm list is surfaced, and never as a nag.

Commit the workspace with a plain message (the repo is the backup): the files you wrote in
Steps 5 to 6b, `SYSTEMS.md` when Step 1b seeded it, `WAITING-ON-YOU.md`, and `.base/` if git
shows it unsaved (the engine's memory of this business belongs to the business). The transcript, the intake and the brief stay out of git by construction; if git ever
offers them, stop and say so.

## Step 8: Tell the owner (the report)

Three parts, short:

> Your Blueprint is built. Your session framed [F] opportunities; [M] are in the plan[, and
> [S] you struck on the call]. [K] more ideas came up in passing and wait on a quick
> confirmation from your team.
> [When the brief was there: Of the [M] in the plan, [T] came from your session and [B] from
> the Caddy team's notes after it.] [When they disagreed: In [D] place(s) the notes and your
> session said different things; I kept what was said in the session: [one line each, plainly].]
> [When the brief was set aside: The Caddy team's notes came in a shape I could not read, so I
> built from your session alone; they can send a fixed copy.]
> [When the Workbook is there: Your Audit Workbook gave me [Y] systems, your team and your
> numbers; they are in my memory of the business. [When W is not zero: [W] workflow(s) you wrote
> up [are quoted where your session framed them / wait on your word].] [When G is not zero: The
> [G] item(s) you skipped in the Workbook are on your short list.]]

The numbers, so they always add up: F is every opportunity framed with a number in the session
(strikes included); M is what is in the plan after the strikes and updates, and M = T + B, where
T came from the session and B from the brief alone; S is the struck ones (say that clause only
when S is not zero); K is the unframed ideas in section 7, the brief's unconfirmed items
included; D is the disagreements, counted by opportunity; P is the number of phases, one per
phase hint, in the session's order. Y is the Workbook's systems rows, W its workflows and G its
GAPS lines, all from the intake document. Every number comes from the transcript, the brief and
the intake document, never rounded, never guessed. To the owner the brief is "the Caddy team's
notes" and the Workbook is "your Audit Workbook".
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
- Never builds from the brief alone, and never lets the brief overrule the session
- Never turns a Workbook workflow into an opportunity on its own, and never designs against a
  system only the Workbook names
- Never celebrates, the finish line comes much later, and it isn't yours
- Never checks licenses, phones home, or collects anything (there is nothing to check)
- Never uses a word the owner would have to look up
