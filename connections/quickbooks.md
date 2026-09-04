# QuickBooks Online: connect it to your Caddy

**Checked against the vendor's docs:** 2026-09-04. Before handing over any card from this
page, re-check the current docs (links at the bottom). Vendors move menus and URLs, and Intuit
has announced first-party connectors for AI apps that may make the technical path below
unnecessary by the time you read this. Check the Claude app's connector directory first.

**Who grants access:** the person `ACCESS-MAP.md` names for QuickBooks (usually the owner or
the bookkeeper). Every card goes to them.

## 1. What it is

QuickBooks Online is the books: invoices, bills, customers, payments, reports. The plan
touches it when money-related admin is the manual work being retired.

## 2. The sign-up card

The business already has it or it does not; this is the bookkeeper's decision, not a card.

## 3. How your Caddy connects

**Read this first.** Intuit's direct connection is a developer path: it needs an Intuit
developer account, an app with its own client id and secret, and a one-time browser
handshake; for a live company it also needs a public web address for the first
authorization. That is not a level-one card. So the order is:

**Option A (preferred for a level-one owner): through the always-on rail or the app
connector.** n8n has a QuickBooks Online node that signs in to QuickBooks inside n8n, on the
kind of card the owner can do (sign in, click Allow). Zapier's connection does the same. Your
Caddy designs the piece there and QuickBooks never hands anyone a secret. See
`connections/n8n.md` or `connections/zapier.md`. And before either, look for a QuickBooks or
Intuit entry in the Claude app's **Customize > Connectors** directory; if it is there, that
is the whole card: connect, sign in, Allow.

**Option B (a technical team member only): Intuit's official MCP server.** It runs on the
person's own machine and keeps its secrets in its own `.env`, outside this folder. The steps,
from Intuit's page:

> **Your turn (about 30 minutes, technical)**
> 1. Register an app on https://developer.intuit.com and copy its client id and secret.
> 2. Complete the one-time browser sign-in Intuit's README describes (sandbox first; a live
>    company needs a public HTTPS callback for that step).
> 3. Put the values in the server's own `.env` as its README shows. Never paste them here.
> 4. Come back here and type: done
>
> Why: Intuit only hands access to a registered app, and only a person can register one.
> When you're back, I check that it worked without ever reading the values.

Your Caddy then adds the server to this folder's `.mcp.json` as a local command (the README's
Claude Code snippet), with the secrets referenced from the server's own `.env`, and starts
with the read-only tools until the person asks for more.

## 4. The check your Caddy runs

Read the company info, then search customers for one name the person gives. Connected means
they recognise the company name and the customer. Nothing is created, changed or sent.

## 5. What gets built there

Reading invoices and payments to chase what is overdue (the chase itself is drafted for a
person until autonomy is granted), pulling the numbers a weekly brief needs, creating a draft
invoice from a job record for a person to approve. Money never moves by your Caddy's hand.

## 6. The SYSTEMS.md line

| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |
|---|---|---|---|---|---|
| QuickBooks connection | [inside n8n / Zapier, or Intuit's local server on `<machine>`] | [person] | [reads / drafts what the plan says] | the company-info check answers | [date, phase] |

## The docs this page was checked against

- [QuickBooks Online MCP Server (Intuit, official)](https://github.com/intuit/quickbooks-online-mcp-server)
- [Connectors directory](https://claude.com/docs/connectors/directory)
