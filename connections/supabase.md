# Supabase: connect it to your Caddy

**Checked against the vendor's docs:** 2026-09-04. Before handing over any card from this
page, re-check the current docs (links at the bottom). Vendors move menus and URLs.

**Who grants access:** the person `ACCESS-MAP.md` names for Supabase. Every card goes to them.

## 1. What it is

Supabase is a proper database with a friendly face: the durable home for data that must
outlive a spreadsheet, be shared by several tools, or be queried in ways a sheet cannot.

## 2. The sign-up card (only if the business has no Supabase yet)

> **Your turn (about 5 minutes)**
> 1. Open https://supabase.com and create an account with the business email. The free tier
>    is enough to start.
> 2. Create one project. Name it after the business. Pick the region closest to you. Write
>    the database password it asks for somewhere safe of yours (your Caddy never needs it).
> 3. When the project dashboard is open, come back here and type: done
>
> Why: an account and a project are things only a person can open.
> When you're back, I check that it worked before we go on.

## 3. How your Caddy connects

**Option A (preferred): Supabase's own MCP server, with a sign-in.** Your Caddy runs:

```
claude mcp add --transport http supabase "https://mcp.supabase.com/mcp?project_ref=<project id>"
```

(The project id is in the project's settings; your Caddy asks for it or reads it from the
dashboard URL the person pastes. Adding `&read_only=true` is the right default until a phase
needs to write.)

> **Your turn (about 2 minutes)**
> 1. Type `/mcp` here and choose **supabase**, then **Authenticate**.
> 2. A browser window opens. Sign in to Supabase and grant access.
> 3. When the window says it is connected, come back here and type: done
>
> Why: Supabase needs you, not me, to say yes to the connection.
> When you're back, I check that it worked before we go on.

The official plugin is an equivalent route: `/plugin install supabase@claude-plugins-official`.

**Option B: a personal access token in the prepared place.** Only for a script that must run
without the AI app. Your Caddy writes `SUPABASE_ACCESS_TOKEN=<paste here>` to `.env` first;
the person creates the token in their Supabase account settings and pastes it there.

## 4. The check your Caddy runs

Call the Supabase server's list-tables (or list-projects) tool. Connected means the person
sees their project name or a table they recognise. A sign-in error means the browser step
did not finish: hand the card over again.

## 5. What gets built there

Tables that hold the business's records when a spreadsheet stops being enough: a job log, a
customer list several tools read, the numbers behind a report. Your Caddy designs the table
in plain words first ("one row per job, these columns"), the person approves, then it
creates it. Nothing money-making moves here until the old way has been kept running beside
it and the person has retired it.

Not here: anything a single sheet or a file in this folder handles fine.

## 6. The SYSTEMS.md line

| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |
|---|---|---|---|---|---|
| Supabase project `<name>` | supabase.com, project `<id>` | [person] | holds [the tables named in the plan] | `/mcp` shows supabase connected; the tables list answers | [date, phase] |

## The docs this page was checked against

- [Model context protocol (MCP) with Supabase](https://supabase.com/docs/guides/getting-started/mcp)
- [Supabase plugin for Claude Code](https://github.com/supabase-community/supabase-plugin)
