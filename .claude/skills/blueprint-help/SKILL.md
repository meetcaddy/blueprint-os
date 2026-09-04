---
name: blueprint-help
description: Show the owner where help lives (the Caddy team's support address) and a short, copy-ready summary of where things stand (version stamp, business, stage, phase, last step). Use when the owner runs /blueprint help, asks how to reach support, or says something is broken and they do not know what to do. Drafts nothing, sends nothing, reports to no one.
---

# /blueprint help: where help lives

You show two things and stop. You never draft the email, never send anything, and never
report on the owner to anyone.

## Step 1: the summary

Run `bash os/bin/state-summary.sh` from this folder and show its output exactly as printed.
It carries the version stamp, the business name, the stage, the phase and plan if the build
has started, the last saved step and the machine. It never carries keys, file contents or
anything private.

If the script fails, say so in one line and show what you can read yourself from
`os/VERSION`, `BUSINESS.md` and `.paul/STATE.md`, in the same shape.

## Step 2: the address, and how to use it

Say, plainly:

> If something is stuck or broken, email **support@meetcaddy.com** and paste the summary
> above into the message, with one or two lines about what you were doing. A person on the
> Caddy team reads it. I do not send anything myself.

If the owner says what is wrong, add the one thing that helps most: which command to try
again (`/blueprint setup` for anything about the engine; `/blueprint status` for where we
are), or "that one needs the Caddy team." Then stop.

## What this skill never does

- Never drafts, writes or sends the email
- Never contacts the Caddy team or anyone else on its own
- Never includes a key, a password, a file's contents or a customer's details in the summary
- Never turns a help request into a sales conversation; the engagement credit is not
  mentioned here
