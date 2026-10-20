---
name: blueprint-deep-dive
description: Run the Deep Dive with the owner and their operations seat after ingest. The systems access map comes first, then the real context (documents, screens, properly granted access) and a per-opportunity brainstorm, recorded into one design record per phase. Each phase graduates into the build when the owner agrees its context is complete. Use when the owner runs /blueprint deep-dive, says "start the deep dive", or wants to go deeper on a phase before building it.
---

# /blueprint deep-dive: learn the real thing before building anything

Understanding first, building second. The session found the gaps and framed the fixes. This
is where the owner shows you the real business so the fixes get designed where the details
actually live. Speak level one. Ask a few questions at a time, never a wall. Build nothing
here: the build is `/blueprint build`.

## Step 0: Where things stand

1. Read `BUSINESS.md`, `BLUEPRINT.md` and `BLUEPRINT-DIRECTIVES.md`. If any is missing, the
   package has not been ingested. Say: "Your Blueprint is not built yet. When your package
   lands, type /blueprint ingest." Stop.
2. If `design/` already holds records, you are resuming. Find the first phase whose record
   is not marked **Context complete** and say where you are in one sentence. Never restart
   from the top and never rewrite an approved record without the owner's say so.
3. Ask once who is in the room: the owner, the operations seat, anyone else. Write the names
   down. Cards go to the person the access map names, by name. If the operations seat is a
   different person from the owner, write `SECOND-SEAT.md` for them from
   `os/templates/SECOND-SEAT.md` (three minutes to read) and tell the owner it is there to hand
   over. If the seat is the owner, skip it.

## Step 1: The access map, before any brainstorm

Sign-ups and access grants take days. Design does not. So the map comes first, and the
first cards go out today.

1. Create `ACCESS-MAP.md` from `os/templates/ACCESS-MAP.md` if it does not exist. One row
   per system the plan touches: every system `BUSINESS.md` TOOLS marks as in the plan, every
   "that lives in" from the opportunities, and anything the directives name. A system TOOLS
   marks as not in the plan gets one row that says so and nothing else: nobody is asked for
   keys the plan does not need.
2. For each row fill in: what part of the plan needs it, **who grants access** (from the
   session's "[Name] can grant [system]" lines, already in TOOLS), and how the connection
   will happen (a recipe in `connections/` when one exists, otherwise "worked out at phase
   start").
3. Where no grantor was named, ask now, one plain question: "Who can grant me access to
   [system]?" Record the answer. Never guess who holds the keys.
4. Send the first cards: only for what Phase 1 needs, one card at a time, addressed to the
   named grantor (when Phase 1's first piece needs no access, files dropped by hand for
   example, say so in one line and send no card: the access cards come with the plan that
   needs them), in the card shape from `os/templates/handoff-card.md` (its rules for several
   cards, for a person not in the room, and for a sign-up or paid plan all apply). Everything
   else waits for its phase. Mark each row's card status as you go: not yet, sent to [name],
   done, verified. Every card handed over gets a dated line in `WAITING-ON-YOU.md` (create it
   from `os/templates/WAITING-ON-YOU.md`): one line per item, removed the moment it is verified
   done; a card handed over again keeps its first date.

Keys never pass through this chat. A card names the exact place the person types a key
themselves (a file you already prepared with a placeholder, or the tool's own connect
screen), and you prove the connection works without ever reading the value.

## Step 2: Gather the real context, one phase at a time, Phase 1 first

First, the drop folder: run `python3 os/bin/context-index.py --summary` and read
`context/INDEX.md`. Everything the owner dropped is read before anything is asked; if the summary
shows new items, run `/blueprint context` now. Then ask only for what the folder did not give
you, and quote the dropped files by name when you use them.

For each opportunity in the phase, ask for four things:

- **The documents.** SOPs, checklists, templates, example files. Start with what the owner
  already sent the Caddy team in their Audit Workbook (`BUSINESS.md` NOTES lists those samples
  by name): ask for copies of those first. Ask them to drop copies into the slot that fits in
  `context/` (or `context/phase-N/` for a phase-specific request), then run
  `/blueprint context`. Read them. Quote them back in their words.
- **Eyes on the screens.** Ask the owner or the operations seat to open the real software and
  walk through the job while you ask questions. Write the steps down as they happen, in the
  order they happen, in their vocabulary. When their Audit Workbook holds written steps or a
  recording for this workflow, read those back first and ask what has changed.
- **Access.** Only through the map's cards. Never through chat.
- **The numbers.** Every "no number known" in `BUSINESS.md` BASELINES gets either a real
  number now or a week-one measurement plan (what to count, who counts it, for how long).

The questions, a few at a time, in plain words:

1. Walk me through it as it happens today, from the first trigger to the last click.
2. What tells you it is time to do it? Where does it start?
3. Which screens do you touch, in what order? Show me.
4. What decisions happen in the middle? What makes you go one way or the other?
5. Where does it go wrong, and what do you do then?
6. Who else touches it, and who checks it?
7. What must never change? The voice, a format, an approval step, a customer who is special.
8. How would you know it worked?

Never ask what `BUSINESS.md` already answers. Fold every new fact into it as you go.

## Step 3: The brainstorm, per opportunity

Take each opportunity apart with the operations seat until the build's shape is genuinely
understood. Run it as a SEED ideation of type **blueprint** (`/seed blueprint`, one project
per phase, named `deep-dive-phase-N`). SEED keeps its working notes under `projects/`; the
owner never needs to open them. Its sections are the design conversation:

- **What goes in, what the machine does step by step, what comes out.** Concrete. Named
  files, named screens, named fields where you have seen them.
- **The home of each piece.** Their existing tools first. An always-on rail (n8n or similar)
  only when the job must run without you. A proper database only when data needs a durable
  home. A plain script when a script is enough. The simplicity test governs both ways.
- **Where the human stays in the loop, and what stays human for good.** Say why.
- **The sandbox rule.** Nothing that makes money gets disrupted. The old way keeps running
  until the owner retires it.
- **Constraints from the session**, honored by name.
- **How it gets verified on real work this week, and who watches.**
- **The cards this will need**, each with its grantor from the access map.

New ideas the owner raises here are real: they said it, so it is grounded. Write each one
into `amendments.md` with the date and their words, place it in a phase, and say where it
landed. Never refuse one, never derail the current phase for one.

## Step 4: The design record, the moment the design is approved

Write `design/phase-N.md` from `os/templates/design-record.md`: the approved design in plain
words, the home of each piece, what stays human, the cards planned (outcomes filled in later
by the build), the verification duties with a named witness, the exit criteria (the owner's
plain sign-off plus the measured result), and the questions still open for build start.

**The fresh-eyes check, before the read-back.** First write every answer the owner gave in
this conversation into the record's notes, the delegated ones too ("decided by your Caddy after
[name] said: decide the simplest way"): the helper reads files only, and an answer it cannot
read counts as an assumption. Then hand the draft record to a fresh helper that has no memory
of this conversation: start a subagent with the text of `os/prompts/design-duel.md`
and the files it names, including `ACCESS-MAP.md` and `amendments.md` (use the fast model tier
when your app offers one, otherwise the default; the checker must not be this conversation).
Take every finding that points at a line and names its source: fix what was invented, simplify
what was overcomplicated, repair the cards and any sandbox breach, and turn an assumption back
into a question for the owner. Drop any finding without a source. A finding the owner rejects
is written in the record's notes with their words, and not applied. Then tell the owner in one
line what the check changed: "A fresh set of eyes checked this design; it caught [X], so I
changed [Y]." If nothing was found, say that in one line. If the helper cannot run, say so in
one line ("I could not run the fresh-eyes check this time") and go on.

Read the record back to the owner in three lines. They say "approved" or they change it.
Only an approved record can graduate.

## Step 5: Graduate the phase

Ask plainly: "Is there anything about [phase, in their words] I have not seen yet?" And tell
them, once: "The more you give me here, the better everything I build will be."

When the owner agrees the context is complete (or hands you the call: "you decide", "go
ahead"; then say in one line what is still thin, and write "accepted as is by [name]" beside
the mark):

1. Mark the record: **Context complete: [date], approved by [name].**
2. If `.paul/` does not exist yet, create the plan now with `/paul:init`, answering its
   questions yourself from the Blueprint: the core value is the north star from `CLAUDE.md`,
   the project is "Your Blueprint" with one phase per Blueprint phase, in the Blueprint's
   order. Then run `/paul:progress` and confirm it reads cleanly. Only report success after
   it does. If it fails, fix and retry once; if it fails again, say: "The plan file did not
   build right. Email support@meetcaddy.com and the Caddy team will sort it out. Your
   Blueprint and everything we learned today are safe."
3. If `.paul/` exists, confirm the phase is in the roadmap.
4. Say: "Phase [N] is ready to build. Type /blueprint build when you want to start."

Phase 1 graduates first and fast. It is the first win: the smallest automation the owner can
see working inside seven days of starting the build. If the phase's design is bigger than a
week, split it in the record: the week-sized piece first, the rest as the next plan in the
same phase. The Deep Dive for later phases continues in later sessions while Phase 1 builds.

## Step 6: Record and report

Before you stop: update `BUSINESS.md` (vocabulary, tools, baselines, notes), the card
statuses in `ACCESS-MAP.md`, `WAITING-ON-YOU.md` (every card and question still open, dated),
`SYSTEMS.md` if anything outside you was connected (what, where, whose account, how to check
it), and `amendments.md`. Then commit the workspace with a
plain message, because the repo is the backup.

Report in three parts, level one:

> **What I learned.** [Two or three sentences in their words.]
>
> **What is ready.** [Phases with context complete, or "none yet, we keep going."]
>
> **Waiting on you.** [Cards out, by name. Questions open. Or "Nothing. I'm ready when you
> are."]

## What this skill never does

- Never builds anything, never changes a live system: that is `/blueprint build`
- Never asks for a password, a key, or a card number, and never reads one
- Never guesses who grants access or what a number is
- Never promotes something into the plan the owner did not say or confirm
- Never mentions the engagement credit
- Never reads a design back to the owner before the fresh-eyes check has run (or been found
  unable to run)
- Never uses a word the owner would have to look up
