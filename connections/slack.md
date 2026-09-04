# Slack: connect it to your Caddy

**Checked against the vendor's docs:** 2026-09-04. Before handing over any card from this
page, re-check the current docs (links at the bottom). Vendors move menus and URLs.

**Who grants access:** the person `ACCESS-MAP.md` names for Slack, plus the workspace admin
for the one-time approval. Every card goes to them by name.

## 1. What it is

Slack is where the team talks. The plan uses it to read what happened in a channel, to post
a report where people already look, or to send a message a person has approved.

## 2. The sign-up card

The business either has Slack or it does not; creating a workspace is the owner's decision.
Slack's MCP connection needs the workspace admin to approve it once.

> **Your turn (about 3 minutes, for the workspace admin)**
> 1. In Slack, open the workspace's admin settings and find the approvals for MCP or AI
>    client integrations (Slack's own page, linked at the bottom, shows where they sit today).
> 2. Approve the Slack MCP server for this workspace.
> 3. Come back here and type: done
>
> Why: only an admin can open this door for the whole workspace.
> When you're back, I hand the connection card to the person who will use it.

## 3. How your Caddy connects

**Option A (preferred): Slack's official plugin.** It installs Slack's own MCP server and
asks for a sign-in on first use.

> **Your turn (about 3 minutes)**
> 1. Type `/plugin install slack@claude-plugins-official` here.
> 2. The first time your Caddy reaches for Slack, a browser window opens. Sign in to the
>    workspace and click **Allow**.
> 3. When the window says it is connected, come back here and type: done
>
> Why: Slack needs you, not me, to say yes to the connection.
> When you're back, I check that it worked before we go on.

The same server can be added by hand instead: `claude mcp add --transport http slack
https://mcp.slack.com/mcp`, then `/mcp` and **slack** for the sign-in. Same result.

**Option B: inside the always-on rail.** When a message must post while your Caddy is closed,
the Slack connection lives inside n8n (its Slack node signs in on its own card).

## 4. The check your Caddy runs

Ask Slack for the list of channels the person can see, and read the last message of one
channel they name. Connected means they recognise the channel names and the message. Nothing
is posted in the check.

## 5. What gets built there

A daily or weekly brief posted to a channel the person names; an alert when something in the
plan needs a human; reading a channel for the decisions it holds. Every post goes out under
the connected person's own Slack permissions, so it can never do more than they can. Posts
are drafted for approval until the owner grants autonomy in `BUSINESS.md`.

## 6. The SYSTEMS.md line

| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |
|---|---|---|---|---|---|
| Slack connection | the `<name>` workspace, Slack MCP server | [person] | [reads / posts what the plan says] | the channel list check answers | [date, phase] |

## The docs this page was checked against

- [Slack MCP server](https://docs.slack.dev/ai/slack-mcp-server/)
- [Connect to Claude](https://docs.slack.dev/ai/slack-mcp-server/connect-to-claude/)
- [Slack MCP and Skills plugin](https://github.com/slackapi/slack-mcp-plugin)
