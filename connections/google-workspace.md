# Google Workspace: connect it to your Caddy

**Checked against the vendor's docs:** 2026-09-04. Before handing over any card from this
page, re-check the current docs (links at the bottom). Vendors move menus and URLs.

**Who grants access:** the person `ACCESS-MAP.md` names for Google (usually the owner of the
business's Google account). Every card goes to them.

## 1. What it is

Google Workspace is the business's mail, calendar and files: Gmail, Google Calendar, Google
Drive, Docs and Sheets. Most plans touch at least one of them.

## 2. The sign-up card

Almost every business already has this. If not, the owner creates the Google Workspace
account for the business domain themselves; that is a business decision, not a card.

## 3. How your Caddy connects

**Option A (preferred): the ready-made connectors in your AI app.** No keys, no developer
console. The Claude app ships connectors for Google Drive, Gmail and Google Calendar; a
connector added there is available to your Caddy in Code mode too (checked on our own machine
on 2026-09-04).

> **Your turn (about 3 minutes)**
> 1. In the Claude app, open **Customize**, then **Connectors**, and click the **+** next to
>    Connectors.
> 2. Pick **Google Drive** (or **Gmail**, or **Google Calendar**, whichever the plan needs),
>    click **Connect**, sign in with the business Google account and click **Allow**.
> 3. When the connector shows as connected, come back here and type: done
>
> Why: Google needs you, not me, to say yes to the connection.
> When you're back, I check that it worked before we go on.

Repeat the card once per Google product the plan needs. Team plans may show a **Request**
button instead of **Connect**; then the person who administers the Claude plan approves it
first, on its own card.

**Option B: inside the always-on rail.** When a workflow must read mail or files while your
Caddy is closed, the Google connection lives inside n8n (its Gmail, Drive, Sheets and
Calendar nodes each sign in with Google on their own card). See `connections/n8n.md`.

**Option C (technical team member only): Google's own MCP servers.** Google publishes remote
servers for Gmail, Drive, Docs, Sheets, Slides, Calendar, Chat and People, but they require a
Google Cloud project, enabled APIs and an OAuth client of your own. Your Caddy does not hand a
level-one owner this path; it names it for a technical person if one exists.

## 4. The check your Caddy runs

Ask the connector for the three most recent files in Drive (or the next three calendar
events, or the subject lines of the last three emails). Connected means the person recognises
what comes back. Nothing is written, sent or changed in the check.

## 5. What gets built there

Reading the inbox for a trigger, filing an attachment into the right folder, drafting a reply
the person sends, putting a booking on the calendar, reading or writing a sheet the business
already keeps. Every message that would leave the business is drafted, never sent, until the
owner grants that autonomy in `BUSINESS.md`.

Not here: a database (see Supabase) or a workflow that must run around the clock (see n8n).

## 6. The SYSTEMS.md line

| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |
|---|---|---|---|---|---|
| Google [Drive / Gmail / Calendar] connector | the Claude app, Customize > Connectors | [person] | [what the plan reads or writes] | the recent-items check answers with things the person recognises | [date, phase] |

## The docs this page was checked against

- [Use connectors to extend Claude's capabilities](https://support.claude.com/en/articles/11176164-use-connectors-to-extend-claude-s-capabilities)
- [Connectors overview (platform availability)](https://claude.com/docs/connectors/overview)
- [Configure the Google Workspace MCP servers](https://developers.google.com/workspace/guides/configure-mcp-servers) (the technical path)
