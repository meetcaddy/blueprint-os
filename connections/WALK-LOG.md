# Walk log: each recipe walked once for real (the 06-03 gate)

The gate: every recipe is walked once, for real, on a throwaway account, by a person, before
a client sees it. The machine proves the connection without seeing the key. A recipe whose
row below is not "walked" is written against the vendor's current docs (dated on the page)
but has not yet been exercised end to end with a real card and a real sign-in.

What "path verified on our own machine" means: the same connection method is in daily use on
the Caddy team's own machine on the date given (the Claude app's connectors, the Supabase and
Slack servers). It proves the method exists and works; it does not replace the throwaway
walk, which is what catches a wrong menu name in a card.

| Recipe | Docs checked | Path verified on our own machine | Walked on a throwaway account | By | Result / defects |
|---|---|---|---|---|---|
| n8n | 2026-09-04 | no | not yet | | |
| Supabase | 2026-09-04 | 2026-09-04 (Supabase connector in daily use) | not yet | | |
| Google Workspace | 2026-09-04 | 2026-09-04 (Drive, Gmail, Calendar connectors in daily use, visible in Code mode) | not yet | | |
| Slack | 2026-09-04 | 2026-09-04 (Slack connector in daily use) | not yet | | |
| QuickBooks Online | 2026-09-04 | no | not yet | | |
| HubSpot | 2026-09-04 | no | not yet | | |
| Airtable | 2026-09-04 | no | not yet | | |
| Notion | 2026-09-04 | no | not yet | | |
| Zapier | 2026-09-04 | no | not yet | | |
| Make | 2026-09-04 | no | not yet | | |

## How to walk one

1. Create the throwaway account the recipe's sign-up card describes (a person does this;
   the machine never creates accounts or types passwords).
2. Open this folder in Code mode and type `/blueprint connect [tool]`.
3. Do exactly what the cards say, nothing more. Note every place a card's wording did not
   match the screen.
4. Watch the check. The machine must show the result and must never have asked for the key
   in the conversation.
5. Fill in the row above. A mismatch is a defect: fix the recipe the same day and re-walk.
