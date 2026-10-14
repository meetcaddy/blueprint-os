---
name: blueprint-context
description: Read what the owner dropped into the context folder (SOPs, org charts, financials, estimates, screenshots, recordings), keep INDEX.md current, fold what was learned into BUSINESS.md, and say what would help most next. Use when the owner runs /blueprint context, says "I dropped some files" or "read what I dropped", or when status shows new items in the drop folder.
---

# /blueprint context: read what they dropped

The drop folder is where the owner gives you the real business. Read before you ask. Everything
stays on this computer; you save only the index and what you learned. Speak level one.

## Step 0: index first

Run `python3 os/bin/context-index.py` from this folder. It rewrites `context/INDEX.md` (what is
here, slot by slot, with a status per file) and prints a one-line summary. Read `context/INDEX.md`.
Never open a file the index marks "waiting on you".

## Step 1: anything waiting on the owner comes first

- **A file that looks like a key or password file** (by its name): say its name, ask them to move
  it out of the folder, and do not open it. "`passwords.txt` looks like a password file. I have
  not read it. Please move it out of the folder."
- **A readable file where one line looks like a key:** name the file and the line number, ask them
  to take that line out or remove the file, and do not use the file until they say it is done.
  Never repeat the line.
- **A file that may hold personal ID numbers:** ask once whether you may use it ("`money/ids.txt`
  may hold personal ID numbers. Do you want me to use it, or leave it?"). Leave it until they say
  yes. Write their answer in `BUSINESS.md` NOTES so you never ask twice.
- **Anything private beyond ordinary business data** that you meet while reading (medical
  records, someone's personal finances): stop, say in one plain sentence what kind of thing you
  saw without repeating it, and ask.

## Step 2: read what is new, one file at a time

For every readable item marked "(new)":

- **Word, Excel, PowerPoint, text, spreadsheets, web pages:** run
  `python3 os/bin/extract_text.py context/<slot>/<file>` and read what it prints. It writes
  nothing to disk.
- **PDFs and images:** open them directly; you read PDFs and pictures yourself.
- **Recordings:** see Step 4.
- **A long file:** read the first part, say what it is, and ask which part matters most before
  reading the rest.
- **A file that would not read** (empty, protected or damaged): say so by name, once.

Quote their documents in their words. Where a document and the session disagree, say so; the
owner decides which is current, and you write the answer down.

## Step 3: write down what you learned

Open `context/INDEX.md` and fill the block between `<!-- learned:start -->` and
`<!-- learned:end -->`: one line per file you read, in this shape: "`slot/file`: what it is, and
what it tells me (the opportunity it serves)". Keep the earlier lines; add to them. The index
script keeps this block exactly as you wrote it on every re-run.

Then fold the facts into `BUSINESS.md` (TEAM, VOCABULARY, TOOLS, BASELINES, NOTES), naming the file
as the source ("per `how-we-work/estimate-sop.docx`"). Never invent. A number you did not read
stays blank.

Fill the block between `<!-- missing:start -->` and `<!-- missing:end -->` with what would help
next: three to five lines, each naming the slot to drop it in, taken from the directives and the
open design records (the phase-start interview lists tell you what is still unseen).

## Step 4: recordings

A recording needs a transcript before you can read it. Offer the easiest way, once per recording:

1. If the app that made it can export a transcript (Loom, Zoom, Fathom and the Mac's Voice Memos
   can), ask the owner to drop the transcript file next to the recording with the same name. The
   index then shows "recording with a transcript next to it", and you read the transcript.
2. Otherwise ask the owner to tell you the three things the recording shows, in a few lines, and
   write those down as their words.

You never install a transcriber on your own. If the owner wants one, say the Caddy team walks that
with them (support@meetcaddy.com) and leave it there.

## Step 5: save and report

Commit the workspace with a plain message. `context/INDEX.md` and `BUSINESS.md` are the only
context files git keeps; the raw files stay on this computer by design. Then report in three parts:

> **What I read.** [the files, one line each, in their words]
>
> **What changed in what I know.** [two or three lines]
>
> **What would help next.** [the top one or two items, with the slot to drop them in, or
> "Nothing right now."]

## What this skill never does

- Never opens a file the index marks as waiting on the owner; never repeats a key, a password or
  an ID number
- Never copies a dropped file anywhere, never commits one, never sends one
- Never installs anything
- Never invents a fact or a number a file did not give it
- Never uses a word the owner would have to look up
