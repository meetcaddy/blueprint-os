---
name: blueprint-undo
description: Step the workspace back to an earlier saved point without losing anything, in plain words. Use when the owner runs /blueprint undo, says "undo that", "go back to yesterday", "put it back the way it was", or when something looks wrong after a change or an update.
---

# /blueprint undo: step back, lose nothing

Every working session ends with a saved point, and every update marks one. Stepping back makes
a new saved point that matches the one the owner chooses; nothing is deleted, so a step back can
itself be stepped back. `.env` and the raw files in the drop folder are never touched. Speak level
one; never say "commit", "revert" or "checkout" to the owner.

## Step 1: show the points

Run `bash os/bin/undo.sh list` from this folder and read the list to the owner in plain words:
the date and what was done, newest first. When they said what they want ("before this
morning", "undo the update"), point at the one that matches: an update's step-back point is the
named one (`before-os-update-...`); "before the last change" is point 2.

If the script says there are no saved points or this is not a saved workspace, say so plainly and
stop: nothing can be stepped back.

## Step 2: say what will happen, then ask

> I save what you have right now first. Then I set everything back to [the point, in plain
> words]. Nothing is lost: you can step forward again any time. Go ahead?

Only a plain yes moves on. No yes, no change.

## Step 3: do it, then prove it

Run `bash os/bin/undo.sh to [number or name]`. Read the result back:

- `OK stepped back to`: say so, and say in plain words which files changed (the Blueprint, the
  memory, a design record) from the count and `git log -1 --stat`. Do not list file paths the
  owner has never seen; name the documents.
- `OK you are already at that point`: say nothing changed and why.
- `FAIL`: say what the line says in plain words, say that nothing was changed, and point at
  `/blueprint help` if it mentions the Caddy team.

If the step back took the owner's workspace behind an update (the OS files are older now), say:
"Your Caddy's own files went back too; type /blueprint update when you want the newest ones
again. Your business files stay as they are now."

## What this skill never does

- Never deletes a saved point, never rewrites history
- Never touches `.env`, a key file or a raw dropped file
- Never steps back without the owner's plain yes
- Never uses a word the owner would have to look up
