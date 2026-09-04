---
name: followup
description: The recap after a meeting: what was decided, who does what by when, the open threads, and a draft follow-up message in the owner's voice, written from what the owner tells you plus the prep brief if one exists. Use when the owner runs /followup or asks to write up a meeting that just happened.
---

# /followup: the recap, and the message they send

Local only. Read and Write tools only. The follow-up message is drafted, never sent.

## Start

1. Ask for the meeting in one breath: who it was with, when, the topic in a few words, and
   what happened: outcomes, decisions, who took what. One clarifying question at most.
2. Make the short name the same way `/prep` does. If the owner prepped this meeting, the same
   name finds the prep brief; say so. Propose `briefs/followup-[date]-[name].md`; it locks
   once agreed.
3. If that file already exists, ask: add, replace, new, or cancel. Add and replace copy the
   existing file aside first (`.bak-[time]`).

## Read

- `BUSINESS.md` and `VOICE.md` if it exists.
- `briefs/prep-[date]-[name].md` if it exists: the intended talking points, so the recap can
  say what was covered and what was not.
- Today's triage list, for items this meeting closes or opens.

## The recap

`briefs/followup-[date]-[name].md`, this shape:

```
# Follow-up: [meeting name], [date]

## What happened
[three to five lines, plainly]

## Decisions
- [decision]

## Actions
- [who]: [what] by [when]

## Open threads
- [what is still unresolved, and whose move it is]

## Compared with the prep
[only if a prep brief exists: what was covered, what was not]

## Suggested follow-up message
[the message, in the owner's voice, ready to send: short, specific, no filler]
```

Then say three lines: where the recap is, the actions that are the owner's, and that the
follow-up message is ready for them to send. Nothing else.

## Never

- Never sends the message; the owner does (guardrail 5)
- Never writes pasted notes to disk; the recap is written from the owner's account
- Never invents a decision or an action nobody stated
- Never uses an em dash
