#!/bin/sh
# Prove a file or folder is where it should be.
set -u
label="${1:?label}"; path="${2:?path}"
if [ -e "$path" ]; then echo "$label: present ($path)"; exit 0; fi
echo "$label: missing ($path)"; exit 1
