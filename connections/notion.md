# Notion: connect it to your Caddy

**Checked against the vendor's docs:** 2026-09-04. Before handing over any card from this
page, re-check the current docs (links at the bottom). Vendors move menus and URLs.

**Who grants access:** the person `ACCESS-MAP.md` names for Notion. Every card goes to them.

## 1. What it is

Notion is the team's pages and databases: SOPs, notes, project boards, wikis. The plan
touches it when the manual work is in keeping those pages current.

## 2. The sign-up card (only if the business has no Notion yet)

> **Your turn (about 4 minutes)**
> 1. Open https://www.notion.com and create an account with the business email. The free
>    plan is enough to start.
> 2. Create one workspace named after the business.
> 3. When you can see it, come back here and type: done
>
> Why: an account is a thing only a person can open.
> When you're back, I check that it worked before we go on.

## 3. How your Caddy connects

**Option A (preferred): Notion's own MCP server, with a sign-in.** Your Caddy runs:

```
claude mcp add --transport http notion https://mcp.notion.com/mcp
```

> **Your turn (about 2 minutes)**
> 1. Type `/mcp` here and choose **notion**.
> 2. A browser window opens. Sign in to Notion, pick the workspace, and click **Allow**.
> 3. When the window says it is connected, come back here and type: done
>
> Why: Notion needs you, not me, to say yes to the connection.
> When you're back, I check that it worked before we go on.

The official plugin is an equivalent route: `/plugin install notion@claude-plugins-official`.
The connection sees what the signed-in person can see, nothing more.

**Option B: inside the always-on rail.** For a workflow that must run while your Caddy is
closed, the Notion connection lives inside n8n (its Notion node signs in on its own card).

## 4. The check your Caddy runs

Search Notion for the title of a page the person names, and read its first lines back.
Connected means they recognise it. Nothing is created or changed in the check.

## 5. What gets built there

Meeting decisions filed into the right page for approval, an SOP updated from what actually
changed, a database row added from a form or an inbox, a weekly page a person used to write
by hand. Pages are drafted for approval until the owner grants autonomy in `BUSINESS.md`.

## 6. The SYSTEMS.md line

| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |
|---|---|---|---|---|---|
| Notion connection | workspace `<name>`, Notion MCP server | [person] | [reads / writes what the plan says] | the page search check answers | [date, phase] |

## The docs this page was checked against

- [Get started with Notion MCP](https://developers.notion.com/guides/mcp/get-started-with-mcp)
- [Notion plugin for Claude Code](https://github.com/makenotion/claude-code-notion-plugin)
