# SYSTEMS.md: everything built or touched outside your Caddy

> The systems ledger. One line per external thing: what it is, where it lives, whose account
> it runs under, what it does, and how to check it is healthy. Locations, never credentials.
> This is the maintain-mode checklist and the finish-line inventory.

| What | Where it lives | Whose account | What it does | How to check it is healthy | Since |
|---|---|---|---|---|---|
| [name] | [the tool, workspace, folder or URL] | [person] | [one line] | [what to open and what you should see; and when a check fits, add it: check: `bash os/checks/http-ok.sh "[name]" [url]`] | [date, phase] |

> The "how to check" cell may carry one check your Caddy runs with `/blueprint health`, written as
> ``check: `bash os/checks/<script> ...` `` (the scripts are listed in `os/checks/README.md`) or a
> `connections/bin/` check, or a script in the business's own `checks/` folder. Anything else in
> the cell is read as words for a person. A check only looks: a web address that starts something
> (a webhook) is never a check.
