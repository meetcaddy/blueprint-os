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
   down. Cards go to the person the access map names, by name.

## Step 1: The access map, before any brainstorm

Sign-ups and access grants take days. Design does not. So the map comes first, and the
first cards go out today.

1. Create `ACCESS-MAP.md` from `os/templates/ACCESS-MAP.md` if it does not exist. One row
   per system the plan touches: every system in `BUSINESS.md` TOOLS, every "that lives in"
   from the opportunities, and anything the directives name.
2. For each row fill in: what part of the plan needs it, **who grants access** (from the
   session's "[Name] can grant [system]" lines, already in TOOLS), and how the connection
   will happen (a recipe in `connections/` when one exists, otherwise "worked out at phase
   start").
3. Where no grantor was named, ask now, one plain question: "Who can grant me access to
   [system]?" Record the answer. Never guess who holds the keys.
4. Send the first cards: only for what Phase 1 needs, one card at a time, addressed to the
   named grantor, in the card shape from `os/templates/handoff-card.md`. Everything else
   waits for its phase. Mark each row's card status as you go: not yet, sent to [name],
   done, verified.

Keys never pass through this chat. A card names the exact place the person types a key
themselves (a file you already prepared with a placeholder, or the tool's own connect
screen), and you prove the connection works without ever reading the value.

## Step 2: Gather the real context, one phase at a time, Phase 1 first

For each opportunity in the phase, ask for four things:

- **The documents.** SOPs, checklists, templates, example files. Ask them to drop copies into
  `context/phase-N/`. Read them. Quote them back in their words.
- **Eyes on the screens.** Ask the owner or the operations seat to open the real software and
  walk through the job while you ask questions. Write the steps down as they happen, in the
  order they happen, in their vocabulary.
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

Read the record back to the owner in three lines. They say "approved" or they change it.
Only an approved record can graduate.

## Step 5: Graduate the phase

Ask plainly: "Is there anything about [phase, in their words] I have not seen yet?" And tell
them, once: "The more you give me here, the better everything I build will be."

When the owner agrees the context is complete:

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
statuses in `ACCESS-MAP.md`, `SYSTEMS.md` if anything outside you was connected (what,
where, whose account, how to check it), and `amendments.md`. Then commit the workspace with a
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
- Never uses a word the owner would have to look up
