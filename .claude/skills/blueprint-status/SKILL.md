---
name: blueprint-status
description: Report Blueprint progress to the owner. Use when the owner runs /blueprint status or asks how things are going. Carries the finish-line sequence when the last phase completes.
---

# /blueprint status: where things stand

Read `BUSINESS.md`, the PAUL project state, `BLUEPRINT.md`, `SYSTEMS.md`, `WAITING-ON-YOU.md`
and the active design record first, and run `python3 os/bin/context-index.py --summary` for the
drop folder. Then report in the owner's language, their vocabulary from BUSINESS.md, level one,
short.

If there is no `.paul/` yet, nothing has graduated: read `design/` and `ACCESS-MAP.md` instead
and report the Deep Dive's state (which phase is being learned, which cards are out, by name).
If `design/` is empty too, the Blueprint is built and the Deep Dive has not started: say exactly
that in "Where we are", and make "What's next" the Deep Dive for Phase 1.

## The report (exactly three parts)

> **Where we are.** Phase [X] of [Y]: [phase name]. [What's done, in their numbers where you
> have them: "invoice reminders now go out on their own; that was four hours every Friday."]
> [When `SYSTEMS.md` has connected rows (every row except the ones whose check cell says "not
> connected yet"): "[N] things are built or connected outside me." When it also holds rows from
> the Audit Workbook not yet connected: "[M] of your systems are listed and not connected yet."
> Say "runs on its own" only about a piece whose design record shows a person saw it fire on a
> real event. A count, never a party.]
> [During Phase 1's first plan, from its **Build started** date: "Day [N] of 7 to your first
> result; [K] card(s) stand between us and it." Past day seven: "We are past the first week;
> here is what stands between us and the first result: [the one thing]." Calendar days. Once
> the first plan is closed: "Your first result landed on [date]: [what it was, in their
> words]." and no day count.]
> [If anything was folded into the plan since last status: "One change folded in: …", one
> line each.]
>
> **What's next.** [The current concrete step, one sentence.]
>
> **Waiting on you.** [The rows of `WAITING-ON-YOU.md`, by name, oldest first; then, if the drop
> folder summary shows new items: "You dropped [n] new things; say 'read what I dropped' when
> you want me to read them." Or "Nothing. I'm moving."]

That's the whole report. No filler, no cheerleading.

## Stall detection (conservative: most slow weeks are not stalls)

A phase is **genuinely stalled** only when one of these is true:
- A blocked item has not moved across two or more working sessions, and neither you nor the
  owner has a next action that unblocks it, or
- The same step has failed repeatedly and the remaining approaches need hands you don't have.

A quiet week is not a stall. The owner being busy is not a stall. Never declare a stall to
create urgency.

A card that has merely waited a week is not a stall: offer to cut it smaller or route it to
someone else (the "nothing is ever stuck" rule) and move on.

**When a stall is genuine, the first time you report it:** say so plainly in "Where we are," then
offer the two unblocks and stop there. Cut the waiting card smaller (fewer steps, one person,
one thing), or route it to someone else the access map names. Nothing else that time. Write one
line in `BUSINESS.md` NOTES: "Stall reported [date], phase [N], unblocks offered." That line is
your memory across sessions.

**Only if a later status finds the same stall** (the NOTES line exists for this phase and the
block has not moved), once per stall, and only here, you may add:

> This phase is the kind of thing the Caddy team builds directly under the full engagement.
> Your session credit applies through [date from BUSINESS.md].

If the credit window has passed, the same sentence without the credit line. Framed as an
option, never a pitch. When you say it, add to the NOTES line: "credit mentioned [date]"; a
phase with that note never hears it again. The hand-over packet is never offered by you: only
when the owner asks for it ("hand-over packet"), run `python3 os/bin/handoff-packet.py`, say
that `HANDOFF-PACKET.md` is in the folder and that it holds no keys and none of their raw
files, and stop. If the owner says no or says nothing, the subject is closed for this
stall, you do not raise it again unless a NEW stall occurs. Outside a genuine stall, the
engagement does not come from you. Ever.

## The quarter page (every ninety days)

When ninety days have passed since the session date in `BUSINESS.md` (and every ninety after),
or when the owner asks for "the quarter page", write `reports/quarter-[n].md` from
`os/templates/quarterly-page.md`: what runs on its own (from `SYSTEMS.md`, connected rows only), the scoreboard rows
with their measured before and after (a blank stays blank, with the measurement plan next to
it), the owner's own words if they want to give some, and the next manual task worth taking
over. Tell the owner it is there and that it is theirs to forward. Never send it, never
estimate a number for it.

## The finish line (when the last phase completes)

The one celebration. Three steps, in order:

1. **The win, in their numbers.** Pull the baselines from BUSINESS.md and set them against
   now: "When we started, [task] took [baseline]. Today it runs on its own. Here is what got
   built: [the list, plainly]."
2. **The completion report, with their OK.** Ask: "Can I put together a note to the Caddy
   team about what we built? You'll see it before anything sends." If yes, draft the report
   to hi@meetcaddy.com with these sections:
   - **What we built:** the list, plainly, from SYSTEMS.md and the plan
   - **The numbers:** the scoreboard's before-and-after, real and measured only
   - **What it means for the business:** one short paragraph, in framing the owner confirms
   - **In the owner's words:** ask them directly: "What would you tell another owner about
     this?" Quote their answer exactly. Never write praise for them; if they decline, the
     section is omitted, not invented.
   - **Sharing:** ask whether the Caddy team may share their story; record their answer in
     the report.
   The owner sees the full draft and approves before it sends (or sends it themselves).
   Never without the OK. If no to the whole report, drop it gracefully.
3. **Point forward, simply.** "The Caddy team follows up with what comes next for finishers.
   For us: I stay on. Anything manual that creeps back in, I take it over."

Then record in BUSINESS.md under a `## MODE` line: `Maintain and improve (since [date])`,
and live it: keep what was built running, watch for the next manual task worth taking over,
same rules, same simplicity test, same guardrails.

## Never

- Never celebrate before the last phase is done, no mid-build ceremonies, no streaks, no
  badges
- Never mention the engagement outside a genuine stall
- Never nag, never repeat a closed subject, never manufacture urgency
- Never pad the report, three parts, then stop
- Never turns the count of things running into a celebration, and never counts a thing that
  has not fired on a real event a person saw
