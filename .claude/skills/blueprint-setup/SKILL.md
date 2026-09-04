---
name: blueprint-setup
description: Put your Caddy's engine in place on this computer, then run first boot. Use when the owner (or the Caddy team on the install call) runs /blueprint setup, or when anything the engine needs is missing. Safe to run again.
---

# /blueprint setup — the engine, then first boot

You are installing yourself. Do the work; hand the owner only what needs a person. Speak level
one. Never ask for or type a password; when a step needs one, the owner types it themselves.

## Step 1 — Run the installer

From this folder, run:

```
bash setup/setup.sh
```

It checks this Mac, downloads the base program from the template's release page and verifies
its checksum, installs the BASE engine and its hooks, copies the frameworks into place, and
makes this folder a BASE workspace. Every step prints `OK` or `FAIL`, and it ends with a
report.

- If it prints a **YOUR TURN** card, stop and hand that card to the owner word for word. Wait
  for them to say it is done, then run the installer again. Never do the card's steps for them.
- If a step says **FAIL** with no card, read the line, fix what you can (a missing folder, a
  bad network moment: try once more), and run the installer again. If it still fails, tell the
  owner plainly which line failed and that the Caddy team will sort it out
  (support@meetcaddy.com). Do not improvise a different install path.
- Windows: the installer stops on purpose. Say so plainly; the Caddy team finishes the install
  on a follow-up call.

## Step 2 — Prove it, do not assume it

Only after the report says `SETUP COMPLETE`, check the real result yourself:

1. `base --version` answers.
2. `~/.claude/commands/paul`, `seed`, `skillsmith` and `base` exist.
3. `.base/base.toml` exists in this folder.

If any check fails, treat it as a failed step (Step 1 rules). The installer's report is not
proof; your own read-back is.

## Step 3 — First boot

Now follow `FIRST-BOOT.md` exactly:

1. Ask the owner's name and what to call the business. Write both into `BUSINESS.md` (create
   it with just a `## SESSION` block holding `**Owner:**` and the business name; the rest is
   filled at ingest).
2. Say the spoken lines verbatim. Let the moment land.
3. Give the one instruction and stop. Until the Blueprint package arrives, your only job is to
   be ready.

## What this skill never does

- Never types a password, never runs a step that asks for one (that is the owner's card)
- Never installs anything not listed in the installer
- Never phones home, checks a license, or collects anything
- Never starts the Blueprint before the package arrives
