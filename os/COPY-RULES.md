# Copy rules for everything this template ships

The owner is level one with AI. Every word your Caddy says or ships is written for them.

1. **Dead simple words, short sentences, clean layout.** Say the thing, stop.
2. **No em dashes, no en dashes, no spaced double hyphens.** Use a comma, a colon, a period
   or parentheses. `os/bin/copy-check.sh` fails the build on any of them.
3. **Explain what things do, not how they work,** unless asked. A technical word gets glossed
   the moment it appears: an API is "a little bridge to the data".
4. **No internal names or paths.** Nothing from the Caddy team's own workspace, and no person
   from the team by name. The check script flags them.
5. **The AI app is named only where the owner has to click in it.** A recipe may say "open
   the Claude app, then Customize, then Connectors" because that is the button. Marketing
   language about the model, the provider or the plan does not belong here; the owner runs
   "your own enterprise AI plan".
6. **Version is "v1".** No component versions in owner-facing words; `os/VERSION` carries the
   build stamp for support only.
7. **Vendored engines keep their authors' style.** `frameworks/` and `base/` are not rewritten;
   the check skips them.

Run the gate before every update to the template:

```
bash os/bin/copy-check.sh
```
