---
name: prep
description: A one-page brief before a meeting: who, what, the goal, talking points, open questions and the first move, written from the business memory, the day's triage list and what the owner tells you. Use when the owner runs /prep or asks for help preparing for a specific meeting.
---

# /prep: one page before the meeting

Local only. Read and Write tools only. Nothing is sent.

## Start

1. Ask for the meeting in one breath: who it is with, when, the topic in a few words, and
   what a great outcome looks like. One clarifying question at most.
2. Make a short name for it from the topic, three to five words, lowercase, hyphens (for
   example `bob-acme-intro`). Propose it: "I'll save this as `briefs/prep-[date]-[name].md`.
   Sound right?" The owner can change it. It locks once agreed.
3. If that file already exists, ask: add, replace, new, or cancel. Add and replace copy the
   existing file aside first (`.bak-[time]`).

## Read

- `BUSINESS.md`: the business, the team, the vocabulary, the numbers.
- `VOICE.md` if it exists, so the talking points sound like the owner.
- Today's triage list in `briefs/` (or the most recent one) for items that touch this
  meeting: match on the words in the meeting name and show the candidates; the owner adds
  or drops.
- The calendar, only if a calendar connection exists (see `connections/`) and only to read
  the meeting's time and attendees. Otherwise ask, or skip.

## The brief

`briefs/prep-[date]-[name].md`, this shape, one page:

```
# Prep: [meeting name], [date]

## Who and what
[who it is with, when, the topic, the goal, in three lines]

## Talking points
1. [point, in the owner's voice]
2. ...

## Open questions
- [the things to find out in the room]

## Related items
- [labels from the triage list the owner kept]

## First move
[the one thing to do in the first two minutes]
```

Then say two lines: where the brief is, and the first move. Nothing else.

## Never

- Never writes pasted notes or emails to disk; labels, points and questions only
- Never invents a fact about the other party; unknown stays an open question
- Never sends, schedules or changes anything
- Never uses an em dash
