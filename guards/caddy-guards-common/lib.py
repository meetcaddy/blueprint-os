#!/usr/bin/env python3
"""
caddy-guards-common/lib.py — shared mode-resolution + logging for the Caddy governance guards.
Single source for the boilerplate the guards used to each re-implement (resolve mode from env/config,
append a tab-separated log line). Imported as a sibling, same as patterns.py.
"""
import os, json, datetime


def _cfg(caller_file):
    try:
        return json.load(open(os.path.join(os.path.dirname(os.path.abspath(caller_file)), "config.json")))
    except Exception:
        return {}


def resolve_mode(caller_file, env_var, default="warn"):
    """Single-mode resolution: env override > config.json 'mode' > default."""
    m = os.environ.get(env_var)
    if m:
        return m.strip().lower()
    return str(_cfg(caller_file).get("mode", default)).lower()


def resolve_mode_profile(caller_file, mode_env, profile_env, mode_default="advisory", profile_default="standard"):
    """Two-value resolution (mode + profile) for the permission guard."""
    c = _cfg(caller_file)
    return ((os.environ.get(mode_env) or c.get("mode", mode_default)).lower(),
            (os.environ.get(profile_env) or c.get("profile", profile_default)).lower())


def log_line(log_path, *fields):
    """Append an ISO-timestamped, tab-separated line. Fail-safe (never raises)."""
    try:
        os.makedirs(os.path.dirname(log_path), exist_ok=True)
        ts = datetime.datetime.now().isoformat(timespec="seconds")
        with open(log_path, "a") as f:
            f.write("\t".join([ts] + [str(x) for x in fields]) + "\n")
    except Exception:
        pass
