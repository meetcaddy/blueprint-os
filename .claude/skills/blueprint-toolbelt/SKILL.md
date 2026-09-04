---
name: blueprint-toolbelt
description: The small everyday tools your Caddy can carry (a draft in the owner's voice, a triage of the pile, a meeting prep, a follow-up recap, a start-of-day brief), added only when a phase design calls for one and removed when it no longer does. Use when the owner runs /blueprint toolbelt, asks what tools are available, or a design record names one.
---

# /blueprint toolbelt: tools on demand, never by default

Nothing sits on the machine without a reason. The belt holds five small tools; a tool is
installed when a phase design says the business needs it, and it can be removed any time.

## The belt

| Tool | What it does | Typical reason |
|---|---|---|
| `draft` | Writes something in the owner's voice: an email, a message, a post. Never sends. | a phase where a person still writes the outbound message |
| `triage` | Walks through a pile of inbound items one at a time and writes a short prioritized list. | a phase around the inbox or the task pile |
| `prep` | A one-page brief before a meeting, from the business memory and the day's list. | a phase touching sales or client calls |
| `followup` | The recap after a meeting: decisions, actions, open threads, a draft follow-up. | the same |
| `start-of-day` | The morning brief: priorities, calendar, inbox items, first move. | a phase where the owner wants a daily rhythm |

## Commands

- `bash os/bin/toolbelt.sh list` shows the belt and marks what is installed.
- `bash os/bin/toolbelt.sh add [tool] "[the phase and the design that calls for it]"` installs
  one and writes the reason into `BUSINESS.md` NOTES. A tool is never added without a reason.
- `bash os/bin/toolbelt.sh remove [tool]` takes it off again.

After adding a tool, tell the owner: "/[tool] is ready. Start a fresh session and it is
there." The tool then runs as its own command.

## Rules every tool follows

- Speaks level one, in the business's own vocabulary from `BUSINESS.md`.
- Never sends anything; drafts are the owner's to send.
- Pasted contents (emails, notes) stay in the conversation; what lands on disk is the short
  labels the owner gives, the decisions and the drafts, in `briefs/` in this folder.
- Backup before change: a file that exists is copied aside before it is rewritten.
- No em dashes in anything it writes.

## What this skill never does

- Never installs a tool without a phase and a design behind it
- Never installs anything that is not in `os/toolbelt/`
- Never removes a skill that is not a toolbelt tool
