---
name: blueprint-health
description: Check that everything your Caddy built or connected outside itself is still running, one plain line per system, from the checks written in SYSTEMS.md. Use when the owner runs /blueprint health, asks "is everything still working?", or after a change to a live system.
---

# /blueprint health: is it all still running?

Every outside thing your Caddy built has a row in `SYSTEMS.md` and, when one fits, a check it
can run. This runs them and reports in plain words. Nothing is changed, nothing is sent. Speak
level one.

## Step 1: run the checks

Run `bash os/bin/health.sh` from this folder. It prints one line per system: `running`,
`needs you`, `broken` or `manual`, then a summary line. It never prints a key or a value, only
each check's own status line.

If it says there is no `SYSTEMS.md` yet, say: "Nothing is built outside me yet, so there is
nothing to check." Stop.

## Step 2: tell the owner, in their words

> **Running.** [the systems, by their names in the business, one line]
>
> **Needs you.** [each one: the card that is still open, by name, and who it waits on]
>
> **Not right now.** [each broken one: what the check saw, in plain words, and what you will do:
> retry once now; if it is still broken, the one obvious thing to try, or "this one needs the
> Caddy team" with a pointer to /blueprint help]
>
> **Checked by hand.** [each manual row: what to open and what to look for, from its cell]

Leave out any part that is empty. No celebration: a list of things running is a list, not a win.

## Step 3: fix what you can, record the rest

- A broken check: try it once more. If it passes, say so. If not, say what you see and, when the
  fix is a keyboard step you can do without touching a live system, do it and re-check with the
  owner watching. Anything else gets a plain sentence and a line in `WAITING-ON-YOU.md` or a
  note in `SYSTEMS.md`.
- A row with no runnable check: when you build or touch that system next, write one (see
  `os/checks/README.md`).

## What this skill never does

- Never changes a live system to make a check pass
- Never prints a key, a password or a value a check might see
- Never runs anything from a row except the shipped checks in `os/checks/` and `connections/bin/`
- Never counts a thing as running on its own success signal alone; a person saw it fire first
