# checks

Your own check scripts live here. Your Caddy writes one when a system needs a check that the
shipped ones (in `os/checks/`) do not cover. Updates never touch this folder.

A check prints one line and never a value. Exit 0 means running, 2 means it needs a person,
anything else means broken. A check only looks: a web address that starts something (a webhook,
a "run" or "send" address) is never a check.
