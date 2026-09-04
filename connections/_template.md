# [Tool]: connect it to your Caddy

**Checked against the vendor's docs:** [YYYY-MM-DD]. Before handing over any card from this
page, re-check the current docs (links at the bottom). Vendors move menus and URLs. A card
with a wrong step costs the owner an hour and their trust.

**Who grants access:** the person `ACCESS-MAP.md` names for this system. Every card below goes
to them, by name.

## 1. What it is

[One line, in plain words: what the tool does for a business and why the plan wants it.]

## 2. The sign-up card (only if the business has no account yet)

> **Your turn (about [N] minutes)**
> 1. Open [signup link].
> 2. Create the account with [the business email]. Choose [the plan or free tier the plan
>    needs, stated plainly].
> 3. When you can see [the tool's home screen], come back here and type: done
>
> Why: an account is a thing only a person can open.
> When you're back, I check that it worked before we go on.

## 3. How your Caddy connects

Pick the first option that applies. Never both at once.

**Option A: the connection inside your AI app (sign in and click Allow).** [Exact steps: the
plugin install command, or the `claude mcp add` command, or the Connectors menu path. Then the
`/mcp` step if a browser sign-in is needed.]

> **Your turn (about [N] minutes)**
> 1. [Step]
> 2. [Step: sign in to the tool in the browser window that opens and click Allow]
> 3. When the window says it is connected, come back here and type: done
>
> Why: the tool needs you, not me, to say yes to the connection.
> When you're back, I check that it worked before we go on.

**Option B: a key typed into the prepared place.** Your Caddy writes the placeholder FIRST
(a line in `.env`, or a command with `<paste here>` in it), then hands over the card. The key
is typed by the person into that place, never into this chat.

> **Your turn (about [N] minutes)**
> 1. In [the tool], go to [exact menu path] and create [an API key / a token] named
>    "Caddy". [Any scope or expiry the plan needs.]
> 2. Open [the prepared file or the terminal] and paste the key where it says `<paste here>`.
>    Save.
> 3. Come back here and type: done
>
> Why: keys belong in the tool's own place, never in a conversation.
> When you're back, I check that it worked without ever reading the key.

If a key ever lands in this chat by mistake, your Caddy says so, does not use it, and asks
the person to revoke it in the tool and make a new one.

## 4. The check your Caddy runs

[One read-only call that proves the connection with the person watching: what your Caddy
calls, what a good answer looks like, and what the person should recognise on screen. For
a key in `.env`, the check is `connections/bin/check-http.sh` or a tool-specific script;
it prints a status and a count, never the key.]

Connected means: [the plain test]. Anything else means not connected: say so, and retry
the step that failed once before asking for help.

## 5. What gets built there

[What kinds of Blueprint pieces belong in this tool, and what does not. The simplicity test
applies: reach for this tool when the job calls for it, never because it is available.]

## 6. The SYSTEMS.md line

| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |
|---|---|---|---|---|---|
| [Tool] connection | [the tool, workspace or instance] | [person] | [what the plan uses it for] | [the check from part 4, in one line] | [date, phase] |

## The docs this page was checked against

- [vendor doc title](URL)
