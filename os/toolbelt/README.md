# The toolbelt

Five small everyday tools your Caddy can carry. None is installed by default. `/blueprint
toolbelt` adds one when a phase design calls for it and removes it when it no longer does.
Each tool is a skill folder here; `os/bin/toolbelt.sh add [tool] "[reason]"` copies it into
`.claude/skills/` and writes the reason into `BUSINESS.md`.

| Tool | Writes |
|---|---|
| `draft/` | nothing on disk; the draft is in the conversation, the owner sends it |
| `triage/` | `briefs/triage-[date].md` |
| `prep/` | `briefs/prep-[date]-[meeting].md` |
| `followup/` | `briefs/followup-[date]-[meeting].md` |
| `start-of-day/` | `briefs/start-of-day-[date].md` |

The shared rules are in `.claude/skills/blueprint-toolbelt/SKILL.md`. Voice comes from
`VOICE.md` in this folder when the owner has filled it (the `draft` tool asks for it once) and
from `BUSINESS.md` always.
