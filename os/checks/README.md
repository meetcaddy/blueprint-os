# checks

Small scripts `/blueprint health` can run for a row in `SYSTEMS.md`. Each prints one line and
never a value. Exit 0 means running, 2 means it needs a person (a card is still open), anything
else means broken. A row names its check in the "How to check it is healthy" cell like this:

```
check: `bash os/checks/http-ok.sh "Invoice reminder" https://example.com/health`
```

Only scripts in this folder, in `connections/bin/` and in the business's own `checks/` folder are
ever run from a row, and never through a shell: nothing after a `;` or `|` in a row is interpreted.
A check only looks. A web address that starts something (a webhook, a "run" or "send" address)
is never a check; use a status or health address, or a file the automation leaves behind.

| Script | Proves | Usage |
|---|---|---|
| `http-ok.sh` | a web address answers | `bash os/checks/http-ok.sh <label> <url> [expected code, default 200]` |
| `file-exists.sh` | a file or folder is there | `bash os/checks/file-exists.sh <label> <path>` |
| `file-fresh.sh` | a file was written recently (an automation that leaves a trace) | `bash os/checks/file-fresh.sh <label> <path> <max age in minutes>` |
| `process-running.sh` | a program is running on this computer | `bash os/checks/process-running.sh <label> <name>` |
