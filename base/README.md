# base

BASE is your Caddy's memory and rules engine: it remembers decisions, rules and learnings across
sessions and surfaces them when they matter. This folder ships the BASE framework layer (the
commands, the skill, and the framework files). The `base` program itself is downloaded by
`/blueprint setup` from this template's release page (`base-v0.10.2`, macOS Apple Silicon) and
its checksum is verified before it is used.

| Piece | Goes to |
|---|---|
| `commands/` | `~/.claude/commands/base` |
| `skill/` | `~/.claude/skills/base` |
| `framework/` | `~/.claude/base-framework` (its `packages/base-mcp` also becomes this workspace's `.base/base-mcp`) |

The global tier (`~/.base-gbl`) and this workspace's `.base/` are created by the program itself
(`base install`, `base scaffold`), so the layout matches the Caddy team's own machines exactly.

Built by Chris Kahler (Chris AI Systems); shipped here as the Caddy team runs it.
