# frameworks

The three build frameworks your Caddy runs on, shipped byte for byte from their pinned sources.
`/blueprint setup` copies them into place under `~/.claude` (the layout the Caddy team runs).

| Framework | What it does for you | Pinned source |
|---|---|---|
| PAUL | Runs your build, one phase at a time, with a plan, a build, a check, and a close for each | meetcaddy/paul at e023ad5 (v0.2.0) |
| SEED | Runs the deep dive: the guided conversation where you show your Caddy the real business before it builds | meetcaddy/seed at ef8f7b3 (v0.1.1) |
| Skillsmith | Lets your Caddy write new skills for your business when a phase needs one | meetcaddy/skillsmith at 0371e97 (v0.1.0) |

Each folder keeps its own LICENSE. Do not edit these folders by hand; updates arrive through
`/blueprint update`.
