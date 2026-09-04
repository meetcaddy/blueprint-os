# guards

Two small safety hooks that watch what your Caddy is about to do, wired in `.claude/settings.json`.

- **caddy-safety-guard** runs before every command or file change. It blocks the handful of
  catastrophic commands outright and warns on risky ones (force pushes, deleting whole folders,
  reading or writing secret files). Mode `warn` by default; see its README.
- **caddy-permission-guard** watches permission prompts and records what it would decide.
  Mode `advisory` by default: it never acts on its own.
- **caddy-guards-common** is the shared code the two use.

They are fail-open: if a guard hits an error it allows the action and says nothing, so a guard
can never wedge your Caddy. Logs go to `~/.caddy/`.
