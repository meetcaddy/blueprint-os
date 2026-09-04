# Your Caddy

Your Caddy is the operating system you take home from your Blueprint session. It lives in this
folder on your computer and has one job: turn what your team said in the session into a
better-run business, one phase at a time.

## What it does

1. **Reads your session.** When your Blueprint package arrives by email, you type one command
   and it reads the recording and builds your Blueprint: what to build, in what order, and why.
2. **Learns the real thing.** Before it builds anything, it asks you to show it how the business
   actually works: the documents, the screens, the people. The more you give it, the better
   everything it builds.
3. **Builds with you.** It does everything it can do from the keyboard. When something needs a
   person, it hands you a short card with a few steps, waits, and checks that it worked.

## Getting started

The Caddy team installs your Caddy with you at the end of your session. After that, three
things matter:

- When your Blueprint package arrives, open this folder in your AI workspace and type
  **/blueprint ingest**.
- When you are ready to go deeper, type **/blueprint deep-dive**.
- When a phase is ready to build, type **/blueprint build**.
- When a phase needs one of your tools, type **/blueprint connect** and the name of the tool.
- Any time you want to know where things stand, type **/blueprint status**.

If you are stuck, type **/blueprint help**. It shows you where to reach the Caddy team
(support@meetcaddy.com).

## What is inside

- `CLAUDE.md` is your Caddy's job description. It reads it every time it starts.
- `.claude/skills/` holds the commands above.
- `frameworks/`, `base/` and `guards/` are the engine. `/blueprint setup` puts them in place.
- `connections/` holds one recipe per tool: how your Caddy connects to it, what you do, and
  how it checks the connection without ever seeing a key.
- Your Blueprint, your business memory and your plan appear in this folder once they are
  built. Everything here is yours.

## Rules your Caddy always follows

- Nothing in your business gets deleted or changed without your say so.
- It keeps a copy of anything before it touches it.
- It never asks for passwords or keys in chat, and it never moves money.
- Nothing leaves your business without your look, unless you decide otherwise.

This repository is the template. Your own copy is made for you at your session and lives in
your own account.

Version: v1. Template status: in build, not yet installed for any client.
