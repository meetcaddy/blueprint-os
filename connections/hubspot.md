# HubSpot: connect it to your Caddy

**Checked against the vendor's docs:** 2026-09-04. Before handing over any card from this
page, re-check the current docs (links at the bottom). Vendors move menus and URLs.

**Who grants access:** the person `ACCESS-MAP.md` names for HubSpot, and a HubSpot admin
for the first connection. Every card goes to them by name.

## 1. What it is

HubSpot is the sales and marketing system: contacts, companies, deals, tickets, emails,
meetings. The plan touches it when the manual work is in the pipeline.

## 2. The sign-up card

The business has HubSpot or it does not; creating a portal is the owner's decision.

## 3. How your Caddy connects

HubSpot's rule: **the admin of the HubSpot account connects first**; after that other users
in the account can connect. Everything the connection does respects the connected person's
own HubSpot permissions.

**Option A (preferred): the connector in your AI app.** Look for **HubSpot** in the Claude
app's **Customize > Connectors** directory first. If it is there, this is the whole card:

> **Your turn (about 3 minutes, the HubSpot admin first)**
> 1. In the Claude app, open **Customize**, then **Connectors**, click **+** and choose
>    **HubSpot**.
> 2. Click **Connect**, sign in to HubSpot and choose what to allow.
> 3. When it shows as connected, come back here and type: done
>
> Why: HubSpot needs you, not me, to say yes, and its admin has to go first.
> When you're back, I check that it worked before we go on.

**Option B: HubSpot's remote MCP server by hand.** Your Caddy runs
`claude mcp add --transport http hubspot https://mcp.hubspot.com`, then the person types
`/mcp`, picks **hubspot** and completes the sign-in in the browser. HubSpot's page (linked
below) walks the admin through creating the MCP auth app the first time; the scopes are set
by what the person allows during that sign-in, not typed anywhere.

**Option C: inside the always-on rail.** For a workflow that must run while your Caddy is
closed, HubSpot's connection lives inside n8n (its HubSpot node signs in on its own card).

## 4. The check your Caddy runs

Search contacts for the person's own name, and read one deal they name. Connected means they
recognise both. Nothing is created, changed or sent.

## 5. What gets built there

Keeping deal records current from a form or an inbox, drafting the follow-up a person sends,
a pipeline brief, a mirror of closed deals into the delivery tool. HubSpot marks activities
and conversations off-limits when its Sensitive Data setting is on; your Caddy says so
plainly if a design needs them.

## 6. The SYSTEMS.md line

| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |
|---|---|---|---|---|---|
| HubSpot connection | portal `<id>`, HubSpot MCP server | [person] | [reads / updates what the plan says] | the contact search check answers | [date, phase] |

## The docs this page was checked against

- [HubSpot MCP Server](https://developers.hubspot.com/mcp)
- [Integrate with HubSpot's MCP server](https://developers.hubspot.com/docs/apps/developer-platform/build-apps/integrate-with-hubspot-mcp-server)
