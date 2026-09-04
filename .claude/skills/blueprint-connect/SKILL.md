---
name: blueprint-connect
description: Connect your Caddy to one of the business's tools by walking its recipe in connections/. The person does only what a person must do (open an account, sign in, click Allow, type a key into the prepared place); keys never pass through the conversation; the connection is proven read-only with the person watching and recorded in SYSTEMS.md. Use when the owner runs /blueprint connect [tool], when a phase design names a tool, or when a card in the build needs a connection.
---

# /blueprint connect [tool]: one tool, one recipe, one card at a time

You are connecting to a tool the plan needs. The recipe knows the steps; you do the keyboard
work and hand the person only what a person must do. Speak level one. Never ask for a key in
this conversation, and never read one.

## Step 0: which tool, which recipe, which person

1. Name the tool in the business's own words (from `BUSINESS.md` TOOLS) and the piece of the
   plan that needs it (the design record). If no phase needs it yet, say so and stop: nothing
   gets connected without a reason.
2. Open `connections/[tool].md`. If there is no recipe, open `connections/_template.md`,
   research the tool's current docs first (its own pages, this week), write a dated recipe
   from the template, and only then continue. Never improvise a card from memory.
3. Read `ACCESS-MAP.md` for who grants access to this tool. If nobody is named, ask the owner
   now, one question, and write the answer down. Every card goes to that person by name.
4. Re-check the recipe's docs links. If a menu name or an address has moved, fix the recipe
   page before handing anything over, and update its checked date.

## Step 1: the sign-up card, only if needed

If the business has no account yet, hand over the recipe's sign-up card, one card, to the
named person. Wait for "done". Then confirm the plain fact the card asked for (the home
screen, the web address) before going on.

## Step 2: the connection

Follow the recipe's part 3. Pick the first option that applies, never two at once.

- **A sign-in connection** (a plugin or an MCP server with a browser sign-in): run the
  install or `claude mcp add` command yourself, then hand over the sign-in card. The person
  types `/mcp`, picks the tool, signs in, clicks Allow, and comes back.
- **A key in the prepared place:** write the placeholder FIRST. Either the `.env` line with
  `<paste here>` (the file is already ignored by git) or the exact terminal command with
  `<paste here>` in it. Then hand over the card. The person creates the key in the tool's own
  menu, pastes it into the prepared place, and comes back.

Rules that never bend:
- One card at a time. Five steps at most. The last step says what to type when they are
  back. One line of why. One line that says you check the result before going on.
- If the person pastes a key into this conversation: say plainly that it must not live here,
  do not use it, ask them to revoke it in the tool and create a new one for the prepared
  place. Then continue as if it had never been shown.
- Never type a password, never fill a sign-in screen, never create an account. Those are the
  person's, always.

## Step 3: the check, with the person watching

Run the recipe's part 4 exactly: one read-only call. For a key in `.env`, run the recipe's
script in `connections/bin/` from this folder; it prints a status and a count, never a value.
Show the result and ask the person whether they recognise what came back. Connected means
they do. Your own success line is never proof.

If it fails: say which step failed in plain words, retry that one step once, and if it fails
again, record it and tell the person what to check (usually the sign-in did not finish, or
the key was pasted with a space). If the tool itself is down, say so, write it in
`SYSTEMS.md`, and move to the next step of the plan that does not depend on it.

## Step 4: record

1. `SYSTEMS.md`: the recipe's part 6 line, filled in. Locations and names, never a value.
2. `ACCESS-MAP.md`: the row's card status becomes **verified [date]**.
3. The active design record: the card issued and its outcome.
4. Commit the workspace with a plain message. `.env` and every key file stay out of the
   commit by construction; if git ever offers one, stop and say so.

## Step 5: tell the person

> [Tool] is connected. I checked it by [the read-only check, in their words] and you saw
> [what they recognised]. It is written down in the systems list. Next: [the plan step this
> unblocks].

## What this skill never does

- Never asks for, reads, stores, echoes or types a key, a password or a card number
- Never creates an account, never signs in, never clicks Allow: those are the person's
- Never hands over a card from memory; the recipe and the vendor's current docs come first
- Never proves a connection by creating, sending or changing anything
- Never connects a tool the plan does not need yet
- Never uses a word the person would have to look up
