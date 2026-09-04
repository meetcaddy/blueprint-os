---
name: blueprint-update
description: Pull the newest version of your Caddy's own files from the template, without touching the business's files. Use when the owner (or the Caddy team on a support call) runs /blueprint update, or when support says a fix has shipped.
---

# /blueprint update: newer Caddy, same business

The template ships fixes and new recipes. This pulls them in. The business's own files
(`BUSINESS.md`, `BLUEPRINT.md`, the directives, the design records, the systems list, the
plan, the briefs, `.env`) are never touched: the list of what the template owns is in
`os/MANIFEST`, and only those paths change.

## Step 1: run the updater

From this folder:

```
bash setup/update.sh
```

It saves any unsaved work first, marks a step-back point, reaches the template, replaces only
the manifest paths, saves the result, and prints what changed: the old version line, the new
one, and how to step back.

- If it prints `NEXT the engine changed`, run `/blueprint setup` once more. Say so to the
  owner in one line: "The engine has new pieces; I put them in place now."
- If it prints `FAIL`, read the line. No internet is the usual cause; try once more later.
  Anything else: hand the owner to `/blueprint help`. Nothing is half-applied: the update
  saves only when every path came through.

## Step 2: prove it

Read `os/VERSION` back and say the build line to the owner in plain words: "Your Caddy is
now on the [date] build." If it still shows the old line, the update did not apply; say so.

## Step 3: tell the owner

> Updated. [What changed, in one or two plain lines from the updater's output.] Your
> business files were not touched. If anything looks different in a bad way, say so and I
> step back to the version from before.

## What this skill never does

- Never touches a file the template does not own (`os/MANIFEST` is the whole list)
- Never runs without saving the owner's work first
- Never skips the read-back of `os/VERSION`
- Never pulls from anywhere but the template
