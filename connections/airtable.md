# Airtable: connect it to your Caddy

**Checked against the vendor's docs:** 2026-09-04. Before handing over any card from this
page, re-check the current docs (links at the bottom). Vendors move menus and URLs.

**Who grants access:** the person `ACCESS-MAP.md` names for Airtable. Every card goes to them.

## 1. What it is

Airtable is a spreadsheet that behaves like a database: tables the whole team can see and
edit, with forms, views and simple automations. Many businesses already keep their real
records here.

## 2. The sign-up card (only if the business has no Airtable yet)

> **Your turn (about 4 minutes)**
> 1. Open https://airtable.com and create an account with the business email. The free tier
>    is enough to start.
> 2. Create one workspace named after the business.
> 3. When you can see it, come back here and type: done
>
> Why: an account is a thing only a person can open.
> When you're back, I check that it worked before we go on.

## 3. How your Caddy connects

**Option A (preferred): Airtable's official plugin, with a sign-in.** It bundles Airtable's
own MCP server.

> **Your turn (about 3 minutes)**
> 1. Type `/plugin install airtable@claude-plugins-official` here.
> 2. The first time your Caddy reaches for Airtable, type `/mcp`, choose **airtable**, and
>    sign in to Airtable in the browser window. Click **Allow**.
> 3. When the window says it is connected, come back here and type: done
>
> Why: Airtable needs you, not me, to say yes to the connection.
> When you're back, I check that it worked before we go on.

**Option B: a personal access token in the prepared place.** For a script that must run
without the AI app, or if the sign-in route is not available on the account. Your Caddy
writes `AIRTABLE_PAT=<paste here>` to `.env` first.

> **Your turn (about 4 minutes)**
> 1. Open https://airtable.com/create/tokens and create a token named "Caddy". Give it these
>    scopes: `data.records:read`, `data.records:write`, `schema.bases:read`,
>    `schema.bases:write`, `data.recordComments:read`, `data.recordComments:write`,
>    `workspacesAndBases:read`. Add the base or workspace the plan uses.
> 2. Copy the token (Airtable shows it once). Open `.env` in this folder with a text editor
>    and paste it where it says `<paste here>`. Save.
> 3. Come back here and type: done
>
> Why: keys belong in a file the tool reads, never in a conversation.
> When you're back, I check that it worked without ever reading the token.

## 4. The check your Caddy runs

- **Option A:** ask the Airtable server for the list of bases. Connected means the person
  recognises a base name.
- **Option B:** run `bash connections/bin/check-airtable-pat.sh`. It reads `.env` itself and
  prints only `HTTP 200` and a base count. Connected means `HTTP 200`.

## 5. What gets built there

The records a team already keeps here stay here: your Caddy reads them for a brief, adds
rows from a form or an inbox, fills fields a person used to retype, and builds a view a
person asked for. A new base only when the plan needs shared records and no tool holds them
yet, designed in plain words and approved first.

## 6. The SYSTEMS.md line

| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |
|---|---|---|---|---|---|
| Airtable connection | workspace `<name>`, base `<name>` | [person] | [reads / writes what the plan says] | the bases list check answers; or `check-airtable-pat.sh` prints HTTP 200 | [date, phase] |

## The docs this page was checked against

- [Airtable MCP server overview](https://airtable.com/developers/agents/mcp/getting-started)
- [Airtable plugin (official marketplace)](https://github.com/Airtable/skills/tree/main/plugins/airtable)
