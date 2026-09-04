# n8n: connect it to your Caddy

**Checked against the vendor's docs:** 2026-09-04. Before handing over any card from this
page, re-check the current docs (links at the bottom). Vendors move menus and URLs.

**Who grants access:** the person `ACCESS-MAP.md` names for n8n. Every card goes to them.

## 1. What it is

n8n is an automation platform: the always-on rail where a workflow runs on its own, day and
night, without your Caddy being open. When the plan says "this must run the moment X
happens," this is usually its home.

## 2. The sign-up card (only if the business has no n8n yet)

n8n Cloud is the simple path. Self-hosting is for a technical team member only.

> **Your turn (about 5 minutes)**
> 1. Open https://n8n.io and choose the cloud version.
> 2. Create the account with the business email. The trial is fine for the first connection;
>    the plan will need a paid tier before anything runs for real (the API is not available on
>    the trial).
> 3. When you can see your n8n home screen, note the web address in the browser bar (it looks
>    like `https://something.app.n8n.cloud`), come back here and type: done
>
> Why: an account is a thing only a person can open.
> When you're back, I check that it worked before we go on.

## 3. How your Caddy connects

**Option A (preferred): n8n's own MCP server, with a sign-in.** It lets your Caddy search
your workflows, create and edit workflows and data tables, and run the workflows you mark as
available. The instance owner or an admin turns it on once.

> **Your turn (about 4 minutes)**
> 1. In n8n, open **Settings**, then **Instance-level MCP**, and turn on **Enable MCP access**.
> 2. On the same screen, under **Connect a client**, copy the **Server URL** (it ends in
>    `/mcp-server/http`). Paste it here.
> 3. Come back here and type: done
>
> Why: only the owner of the n8n account can open this door.
> When you're back, I add the connection and hand you the sign-in step.

Your Caddy then runs, with the URL the person pasted:

```
claude mcp add --transport http n8n https://<their-n8n-domain>/mcp-server/http
```

> **Your turn (about 2 minutes)**
> 1. Type `/mcp` here and choose **n8n**.
> 2. A browser window opens. Sign in to n8n and click **Allow**.
> 3. When the window says it is connected, come back here and type: done
>
> Why: n8n needs you, not me, to say yes to the connection.
> When you're back, I check that it worked before we go on.

**Option B: an API key in the prepared place** (needed when a workflow must be created or
triggered from a script that runs without the AI app, or when the plan is on a tier where the
MCP door is not available). Your Caddy first writes two lines to `.env` in this folder (the
file is never committed):

```
N8N_BASE_URL=https://<their-n8n-domain>
N8N_API_KEY=<paste here>
```

> **Your turn (about 3 minutes)**
> 1. In n8n, open **Settings**, then **n8n API**, and choose **Create an API key**. Name it
>    "Caddy" and pick an expiry (a year is fine; we renew it on a card).
> 2. Copy the key. Open the file `.env` in this folder with a text editor and paste it where
>    it says `<paste here>`. Save.
> 3. Come back here and type: done
>
> Why: keys belong in a file the tool reads, never in a conversation.
> When you're back, I check that it worked without ever reading the key.

## 4. The check your Caddy runs

- **Option A:** call the n8n server's search-workflows tool. Connected means a list comes
  back (even an empty one) with no sign-in error, and the person recognises a workflow name
  on screen if any exist.
- **Option B:** run `bash connections/bin/check-n8n-api.sh`. It reads `.env` itself and
  prints only `HTTP 200` and a workflow count. Connected means `HTTP 200`. A `401` means the
  key was pasted wrong or has expired: hand the key card over again.

## 5. What gets built there

Workflows that must run without your Caddy open: a watcher on an inbox or a form, a nightly
report, a hand-off between two tools the business already uses (n8n has ready-made nodes for
Google, Slack, QuickBooks, HubSpot, Airtable, Notion and hundreds more; each of those signs in
inside n8n, on its own card). Your Caddy designs the workflow, builds it through the MCP
server, and marks it available. The person keeps the old way running until the workflow has
fired on a real event they watched.

Not here: one-off jobs your Caddy can do itself, and anything a plain script in this folder
does more simply.

## 6. The SYSTEMS.md line

| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |
|---|---|---|---|---|---|
| n8n connection | the n8n instance at `<domain>` | [person] | the always-on rail for [the workflows named in the plan] | `/mcp` shows n8n connected; or `check-n8n-api.sh` prints HTTP 200 | [date, phase] |

## The docs this page was checked against

- [Connect to n8n MCP server](https://docs.n8n.io/connect/connect-to-n8n-mcp-server)
- [MCP client connection examples](https://docs.n8n.io/connect/connect-to-n8n-mcp-server/mcp-client-examples)
- [n8n API authentication](https://docs.n8n.io/connect/n8n-api/authentication)
- [MCP Server Trigger node](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-langchain.mcptrigger) (for exposing one workflow as a tool)
