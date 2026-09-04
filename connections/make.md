# Make: connect it to your Caddy

**Checked against the vendor's docs:** 2026-09-04. Before handing over any card from this
page, re-check the current docs (links at the bottom). Vendors move menus and URLs.

**Who grants access:** the person `ACCESS-MAP.md` names for Make. Every card goes to them.

## 1. What it is

Make (formerly Integromat) is a visual automation platform, an alternative rail to n8n. If
the business already runs scenarios in Make, the plan builds there instead of moving them.

## 2. The sign-up card

Only businesses that already use Make get this recipe; for a new rail, `connections/n8n.md`
is the first choice. If the business does want Make:

> **Your turn (about 4 minutes)**
> 1. Open https://www.make.com and create an account with the business email.
> 2. Note the web address after you sign in (it starts with something like `eu2.make.com`
>    or `us1.make.com`); paste that here.
> 3. Come back here and type: done
>
> Why: an account is a thing only a person can open.
> When you're back, I check that it worked before we go on.

## 3. How your Caddy connects

Make's MCP server exposes the scenarios you set to **On demand** scheduling as tools your
Caddy can run. It uses a token the person creates, typed into a command in their own
terminal, never into this chat. Your Caddy prepares the command first, with `<paste here>`
where the token goes:

```
claude mcp add --transport http make https://<zone>/mcp/stateless --header "Authorization: Bearer <paste here>"
```

> **Your turn (about 4 minutes)**
> 1. In Make, click your name in the top-right corner, then **Profile**, then the **API
>    access** tab. Under **Tokens**, click **Add token**, choose the **MCP token** type with the
>    `mcp:use` scope, label it "Caddy", and add it. Copy the token.
> 2. Open the Terminal tab here, paste the command your Caddy prepared, replace
>    `<paste here>` with the token, and press Enter.
> 3. Come back here and type: done
>
> Why: the token belongs in the tool's own place, never in a conversation.
> When you're back, I check that it worked without ever reading the token.

If the connection will not open, Make's docs say to use `/mcp/stream` at the end of the
address instead of `/mcp/stateless`; your Caddy prepares the alternative command.

## 4. The check your Caddy runs

Ask the Make server for its list of tools. Connected means the person recognises the names
of the scenarios they set to On demand (an empty list with no sign-in error also counts:
then the next step is marking a scenario On demand).

## 5. What gets built there

Scenarios the business already runs, extended rather than rebuilt; new scenarios only when
the business has chosen Make as its rail. Your Caddy runs a scenario on demand through the
connection and designs new ones in plain words first.

## 6. The SYSTEMS.md line

| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |
|---|---|---|---|---|---|
| Make connection | `<zone>`, Make MCP server | [person] | runs [the scenarios named in the plan] | the tools list check answers | [date, phase] |

## The docs this page was checked against

- [Make MCP server](https://developers.make.com/mcp-server)
- [Connect using MCP token](https://developers.make.com/mcp-server/connect-using-mcp-token)
- [Usage with Cursor (the config shape)](https://developers.make.com/mcp-server/connect-using-mcp-token/usage-with-cursor)
