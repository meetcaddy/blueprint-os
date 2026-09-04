---
name: blueprint-build
description: Build one phase of the Blueprint with the owner. Read the phase's design record, ask the remaining questions, plan it in PAUL, do every keyboard step yourself, hand the owner one short card when a human is needed, verify on real work with a person watching, keep score, close the phase. Use when the owner runs /blueprint build, says "start phase N", or wants to keep building.
---

# /blueprint build: one phase, with the owner

You do the 80 percent: the files, the configs, the scripts, the commands, the checks. The
owner does the 20 percent only a person can do, one short card at a time. Nothing that
makes money gets disrupted. Speak level one. Build only when clear.

## Step 0: Where we are

1. Read `BUSINESS.md`, `BLUEPRINT-DIRECTIVES.md` (this phase's block), the phase's design
   record in `design/`, and the plan state (`/paul:progress`).
2. The active phase is the lowest phase whose record says **Context complete** and whose
   plans are not all closed. If there is none, say: "Nothing is ready to build yet. The
   Deep Dive for phase [N] is still open. Type /blueprint deep-dive." Stop.
3. If the record exists but is not marked approved and complete, stop and send them to the
   Deep Dive. Never build from an unapproved design.
4. **Phase 1 only, the first win check.** The first plan must be something the owner can see
   working inside seven days of today. If the design is bigger, split it: the week-sized
   piece first, the rest as the next plan in the same phase. Say so in one sentence.

## Step 1: Clarify before touching anything

List the record's open questions, plus anything that is unclear now that you have read the
design against the real system. Ask them, a few at a time, in plain words. Write the answers
into the record. Do not start the plan until every question that changes the build has an
answer. Build only when clear.

## Step 2: Plan (PAUL)

Run `/paul:plan [N]` with the design record as the source. Shape the plan so it fits this
mission:

- One plan per opportunity, or per week-sized piece of one. Small enough to verify on real
  work within the week.
- Every task is one of two kinds. A **keyboard task** is yours: type `auto`. A **person
  task** is a card: type `checkpoint:human-action`, and the task text IS the card, in the
  shape from `os/templates/handoff-card.md`, five steps at most, addressed to the person the
  access map names.
- Every verification is `checkpoint:human-verify` with a named witness: the owner or the
  operations seat sees the real result on real work.
- The plan's boundaries carry the sandbox rule and the session's constraints by name.

Read the plan back to the owner in plain words before anything runs: what will exist when it
is done, what they will be asked to do and roughly when, and what stays exactly as it is until
they retire it. They approve, or they change it.

## Step 3: Apply. Do the 80, hand over the 20

Run `/paul:apply` and work the plan task by task.

**Keyboard tasks (yours).** Write the files, the configs, the scripts. Connect to tools once
access exists. Run the commands. Read the result back. Before you change anything that
already exists, copy it aside and say where the copy lives. Nothing gets deleted or
reconfigured in a live system without the owner's plain yes.

**Cards (theirs).** One card at a time, never two. Prepare everything first: the file with the
placeholder already written, the exact values to type, the link to open, the reason in one
line. Then the card, exactly this shape:

> **Your turn (about [N] minutes)**
> 1. [Step]
> 2. [Step]
> 3. When you see [the thing], come back here and type: done
>
> Why: [one line].
> When you're back, I check that it worked before we go on.

Keys never pass through this chat. The card names the file or screen where the person types
the key themselves; you prove the connection works without ever reading the value. After
every card, verify the real result with them watching before the next card. Record the card
and its outcome in the design record, and in `SYSTEMS.md` when it touched something outside
you.

**Outside tools.** When the design's home for a piece is an always-on rail, a database, or a
tool they already own, set it up with the owner through cards. If `connections/` has a recipe
for that tool, follow it with `/blueprint connect [tool]`; if not, the card carries the steps.
Every outside thing gets its line in `SYSTEMS.md`: what it is, where it lives, whose account,
what it does, how to check it is healthy. Locations, never credentials.

**New ideas mid-build.** Write them into `amendments.md` with the date and the owner's words,
place them in a phase, say where they landed, and keep going. Never derail this phase.

**When something is unclear mid-build**, stop and ask. When something fails, say what failed
in plain words, try the obvious fix once, and if it still fails, record it and move to the
next task that does not depend on it.

## Step 4: Verify with a person watching

Every verification ends with a named human seeing the real result on real work: a real job, a
real record, this week. Your own success signal is never proof. An always-on piece does not
exist until it has fired on a real event and a person saw it fire. Write down what was seen,
by whom, and when, in the design record.

## Step 5: Score, then close the loop

1. Update the scoreboard: the rows this phase was meant to move, in `BLUEPRINT.md` (Keeping
   score) and `BUSINESS.md` BASELINES, with the measured "after" and the date. Measured only.
   Never invent a number.
2. Run `/paul:unify` for the plan. Never skip it.
3. Update the design record: cards issued and their outcomes, the verification results, and,
   when the phase is done, the exit sign-off in the owner's own words plus the measured
   result.
4. Update `SYSTEMS.md` and `amendments.md` if anything changed. Commit the workspace with a
   plain message, because the repo is the backup.

Then one of two things:

- **More plans in this phase.** Say what is next in one sentence and stop, or continue if the
  owner wants to keep going.
- **The phase is done.** Say: "Phase [N] is done. [What runs on its own now, in their
  numbers.] Next: [phase N+1: the Deep Dive for it, or the build if its record is already
  complete]." No ceremony. The one celebration comes at the end of the last phase, and it
  belongs to `/blueprint status`.

## What this skill never does

- Never puts more than five steps on a card, never hands over two cards at once
- Never asks for, reads, stores, or types a password, a key, a card number, or bank details,
  and never moves money
- Never deletes or reconfigures a live system without the owner's plain yes, and never
  changes anything without a copy set aside first
- Never calls a task, a plan, or a phase done on its own success signal
- Never skips the clarifying questions, and never skips `/paul:unify`
- Never celebrates before the last phase, and never mentions the engagement credit
- Never uses a word the owner would have to look up
