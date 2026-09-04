# Connections: the recipes your Caddy follows to reach the tools you already use

A recipe is one page per tool, in six parts: what it is, the sign-up card, how your Caddy
connects, the check it runs, what gets built there, and the line it writes in `SYSTEMS.md`.
`/blueprint connect [tool]` walks one. The person does only what a person must do: open an
account, sign in, click Allow, or type a key into the place your Caddy prepared. Keys never
pass through the conversation, and your Caddy proves every connection without ever reading a
key.

| Tool | Recipe | The simplest path today |
|---|---|---|
| n8n | `n8n.md` | n8n's own MCP server with a sign-in; an API key in `.env` for scripts |
| Supabase | `supabase.md` | Supabase's MCP server with a sign-in |
| Google Workspace | `google-workspace.md` | the Google Drive, Gmail and Calendar connectors in the Claude app |
| Slack | `slack.md` | the official Slack plugin, after the workspace admin approves it |
| QuickBooks Online | `quickbooks.md` | through n8n or Zapier; Intuit's own server is a technical path |
| HubSpot | `hubspot.md` | the HubSpot connector, admin first |
| Airtable | `airtable.md` | the official Airtable plugin; a token in `.env` for scripts |
| Notion | `notion.md` | Notion's MCP server with a sign-in |
| Zapier | `zapier.md` | the official Zapier plugin |
| Make | `make.md` | Make's MCP server with a token typed in the terminal |
| any other tool | `_template.md` | research the current docs first, then write the recipe before any card |

## The rules every recipe carries

1. **Dated, and re-checked before use.** Each page says when it was checked against the
   vendor's docs. Before handing over a card, your Caddy re-reads the current docs (the links
   at the bottom of each page) and fixes the page if a menu or an address moved.
2. **One card at a time, five steps at most,** to the person `ACCESS-MAP.md` names.
3. **Keys never through chat.** A key goes into a file the tool reads or a command the person
   types in their own terminal. If a key lands in the conversation by mistake, your Caddy does
   not use it and asks for it to be revoked and remade.
4. **The check is read-only and witnessed.** Nothing is created, sent or changed to prove a
   connection; the person sees the result and recognises it.
5. **Every connection gets its `SYSTEMS.md` line** and its row in `ACCESS-MAP.md` moves to
   verified.
6. **If a tool is down,** your Caddy says so plainly, records it in `SYSTEMS.md`, and moves to
   the next step that does not depend on it.

## The check scripts (`bin/`)

Small scripts that read `.env` themselves and print a status and a count, never a value:
`check-http.sh` (any tool with a key in a header), `check-n8n-api.sh`, `check-airtable-pat.sh`.

## For the Caddy team

`WALK-LOG.md` records which recipes have been walked for real on a throwaway account and by
whom. A recipe is not trusted until its row says so.
