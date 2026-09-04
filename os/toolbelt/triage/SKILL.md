---
name: triage
description: Walk the owner through a pile of inbound items (emails, messages, tasks) one at a time, decide urgency and action for each, and write a short prioritized list to briefs/. Use when the owner runs /triage or asks for help working through what has piled up.
---

# /triage: the pile, one item at a time

Local only. Nothing is sent, nothing leaves the business. Read and Write tools only.

## Start

1. Work out today's date once, as `YYYY-MM-DD`. The list is `briefs/triage-[date].md`.
2. If that file already exists, ask before anything else:

   > You already triaged today. Add to today's list, replace it, or save a new one? (add /
   > replace / new / cancel)

   Add and replace copy the existing file aside first, to `briefs/triage-[date].md.bak-[time]`.
   New writes `briefs/triage-[date]-[time].md`. Cancel writes nothing.
3. Say what happens, once:

   > Paste or describe what has piled up. We go one at a time: how urgent, what it needs.
   > What you paste stays here in the conversation. The list on disk only carries the short
   > label you give each item and the decision, never the item itself.

## The loop

For each item, in order:

1. **Ask for a short label** if they did not give one: three to five words, their words. Never
   write a label from the pasted body; the owner's label is the only thing that lands on disk.
2. **Propose a tier and an action**, in one line, and ask "sound right?":
   - tier: `today` / `this week` / `later` / `no action`
   - action: `reply` / `schedule` / `delegate` / `archive` / `read later` / `nothing`
3. **One clarifying question at most** when an item is genuinely unclear: "What does this
   one need? A reply, a decision, or just to know?"
4. Accept their call and move on. If they say "all of these are later" or similar, apply it
   to the rest and skip to the end.

If the pile is empty ("nothing today"), say "Nothing to triage." and write no file. If it
is very large (more than about 25 items), offer to do the top 25 now and the rest later.

## The list

`briefs/triage-[date].md`, exactly this shape:

```
# Triage, [date]

## Today (urgent and actionable)
- [label]: [action]

## This week
- [label]: [action]

## Later
- [label]: [action]

## Decided: no action
- [label]
```

Then say, in two lines: how many items, and the first thing to do. Nothing else.

## Never

- Never writes the pasted contents to disk, never a name or a number from inside an item
- Never sends, replies, schedules or delegates anything itself; it lists, the owner acts
- Never uses an em dash
