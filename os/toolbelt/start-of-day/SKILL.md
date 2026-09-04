---
name: start-of-day
description: The morning brief: today's priorities, the calendar, the inbox items that matter, and the first move, written from the business memory, the day's triage list, and the calendar and inbox connections when they exist. Use when the owner runs /start-of-day or asks for their daily brief.
---

# /start-of-day: the morning, on one page

Local only apart from reading the calendar and inbox through connections the owner has
already granted. Nothing is sent.

## Start

1. Work out today's date once. The brief is `briefs/start-of-day-[date].md`.
2. If it already exists, ask: add, replace, new, or cancel. Add and replace copy the
   existing file aside first (`.bak-[time]`).
3. Say what happens, once: "I read your business memory and today's list, look at the
   calendar and the inbox if they are connected, and write today's brief. What you paste
   stays here; the brief carries short labels and my suggestions, not the items themselves."

## Read

- `BUSINESS.md`, `VOICE.md` if it exists, and today's (or the most recent) triage list.
- **Calendar and inbox:** if a calendar or mail connection exists (see `connections/` and
  `SYSTEMS.md`), read today's events and the subject lines of the newest messages. Read
  only. If no connection exists, ask once: "Paste today's calendar and the inbox items that
  matter, or say skip." Never ask for a login.

## The brief

`briefs/start-of-day-[date].md`, exactly these sections, in this order:

```
# Daily brief, [date]

## Today's priorities
1. [the three things that matter most, in the owner's words]

## Calendar
- [time]: [event label]

## Inbox items that matter
- [label]: [what it needs]

## Carried from the list
- [triage items still open today]

## First move
[the one thing to do first, and why in five words]
```

Then say two lines: the first move, and where the brief is. Nothing else.

## Never

- Never writes message bodies or private details to disk; labels only
- Never replies to, files, or changes anything in the calendar or the inbox
- Never invents an event or an item that was not there
- Never uses an em dash
