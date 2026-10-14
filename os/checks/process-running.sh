#!/bin/sh
# Prove a program is running on this computer.
set -u
label="${1:?label}"; name="${2:?process name}"
if pgrep -f -- "$name" >/dev/null 2>&1; then echo "$label: running"; exit 0; fi
echo "$label: not running"; exit 1
