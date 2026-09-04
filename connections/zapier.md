# Zapier: connect it to your Caddy

**Checked against the vendor's docs:** 2026-09-04. Before handing over any card from this
page, re-check the current docs (links at the bottom). Vendors move menus and URLs.

**Who grants access:** the person `ACCESS-MAP.md` names for Zapier. Every card goes to them.

## 1. What it is

Zapier connects thousands of apps without code. For the plan it is two things: a quick way
for your Caddy to act in a tool that has no direct connection yet, and an always-on rail for
a simple workflow. Each action your Caddy runs through it uses tasks from the Zapier plan.

## 2. The sign-up card (only if the business has no Zapier yet)

> **Your turn (about 4 minutes)**
> 1. Open https://zapier.com and create an account with the business email.
> 2. Connect the apps the plan needs inside Zapier (each app asks you to sign in and click
>    Allow). Zapier then makes those apps' actions available to your Caddy.
> 3. When the apps show as connected in Zapier, come back here and type: done
>
> Why: Zapier and each app need you, not me, to say yes.
> When you're back, I check that it worked before we go on.

## 3. How your Caddy connects

**Option A (preferred): Zapier's official plugin, with a sign-in.**

> **Your turn (about 3 minutes)**
> 1. Type `/plugin install zapier@claude-plugins-official` here.
> 2. The first time your Caddy reaches for Zapier, a browser window opens. Sign in to Zapier
>    and click **Allow**.
> 3. When the window says it is connected, come back here and type: done
>
> Why: Zapier needs you, not me, to say yes to the connection.
> When you're back, I check that it worked before we go on.

The same server can be added by hand: `claude mcp add --transport http zapier
https://mcp.zapier.com/api/v1/connect`, then `/mcp` and **zapier** for the sign-in.

## 4. The check your Caddy runs

Ask Zapier for the list of actions it has enabled for your Caddy. Connected means the person
recognises the apps in the list (for example "Gmail: find email", "Google Sheets: add row").
Nothing runs in the check.

## 5. What gets built there

Small, always-on hand-offs between two apps the business already uses, and one-off actions
in a tool that has no direct connection. When a workflow grows past a few steps or needs
logic, n8n is the better rail; your Caddy says so and proposes the move. Task usage is real
money: your Caddy names the expected task count in the design record.

## 6. The SYSTEMS.md line

| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |
|---|---|---|---|---|---|
| Zapier connection | zapier.com, Zapier MCP server | [person] | [the actions and Zaps named in the plan] | the enabled-actions check answers | [date, phase] |

## The docs this page was checked against

- [Zapier MCP clients](https://docs.zapier.com/mcp/clients)
- [Zapier MCP plugin distribution](https://github.com/zapier/zapier-mcp)
