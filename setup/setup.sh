#!/usr/bin/env bash
# Puts your Caddy's engine in place on this Mac. Run by /blueprint setup.
# Safe to run again: every step checks before it changes anything and reports OK or FAIL.
# Steps that need a person (an admin password, a click) print a YOUR TURN card and stop.
set -u

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
BIN_DIR="$HOME/.local/bin"
BASE_TAG="base-v0.10.2"
BASE_URL="https://github.com/meetcaddy/blueprint-os/releases/download/$BASE_TAG"

FAIL=0
REPORT=()
ok()   { REPORT+=("OK    $1"); echo "OK    $1"; }
fail() { REPORT+=("FAIL  $1"); echo "FAIL  $1"; FAIL=1; }
card() { echo; echo "YOUR TURN: $1"; echo; }
put()  { rm -rf "$2"; mkdir -p "$(dirname "$2")"; cp -R "$1" "$2"; }

echo "== Your Caddy: setup =="
echo "   home: $HOME"
echo "   repo: $REPO"
echo

# 0. This Mac
if [[ "$(uname -s)" != "Darwin" ]]; then
  fail "This installer is for macOS. Windows is not ready yet."; exit 2
fi
if [[ "$(uname -m)" != "arm64" ]]; then
  fail "This Mac is $(uname -m). The base program ships for Apple Silicon (arm64) only right now."; exit 2
fi
ok "macOS on Apple Silicon"

# 1. Command line tools (git)
if xcode-select -p >/dev/null 2>&1; then
  ok "command line tools (git) present"
else
  card "Your Mac needs Apple's command line tools (about 3 minutes).
  1. In Terminal, run:  xcode-select --install
  2. Click Install in the window that opens and let it finish.
  3. Come back here and type: /blueprint setup"
  fail "command line tools missing"; exit 2
fi

# 2. Homebrew (the app installer)
if command -v brew >/dev/null 2>&1; then
  ok "Homebrew present"
else
  card "Your Mac needs Homebrew, the standard app installer (about 5 minutes).
  1. Open https://brew.sh in your browser.
  2. Copy the one-line install command on that page.
  3. Paste it into Terminal and press Return. Type your Mac password when it asks.
  4. When it finishes, come back here and type: /blueprint setup"
  fail "Homebrew missing"; exit 2
fi

# 3. node (runs the BASE tools that talk to your Caddy)
if command -v node >/dev/null 2>&1; then
  ok "node present ($(node --version))"
else
  echo "   installing node with Homebrew (no password needed)..."
  if brew install node >/dev/null 2>&1; then ok "node installed ($(node --version))"; else fail "node install failed"; fi
fi

# 4. python3 (the safety guards)
if command -v python3 >/dev/null 2>&1; then ok "python3 present"; else fail "python3 missing"; fi

# 5. The base program (downloaded from the template's release, checksum verified)
mkdir -p "$BIN_DIR"
EXPECTED="$(curl -fsSL "$BASE_URL/base-darwin-arm64.sha256" 2>/dev/null | awk '{print $1}')"
CURRENT=""
[[ -f "$BIN_DIR/base" ]] && CURRENT="$(shasum -a 256 "$BIN_DIR/base" | awk '{print $1}')"
if [[ -z "$EXPECTED" ]]; then
  fail "could not reach the base program's release page (check the internet connection)"
elif [[ "$CURRENT" == "$EXPECTED" ]]; then
  ok "base program already in place ($("$BIN_DIR/base" --version 2>/dev/null))"
else
  if curl -fsSL "$BASE_URL/base-darwin-arm64" -o "$BIN_DIR/base.tmp" \
     && [[ "$(shasum -a 256 "$BIN_DIR/base.tmp" | awk '{print $1}')" == "$EXPECTED" ]]; then
    mv "$BIN_DIR/base.tmp" "$BIN_DIR/base" && chmod +x "$BIN_DIR/base"
    ok "base program downloaded and verified ($("$BIN_DIR/base" --version 2>/dev/null))"
  else
    rm -f "$BIN_DIR/base.tmp"; fail "base program download or checksum failed"
  fi
fi
export PATH="$BIN_DIR:$PATH"
if ! grep -qs '\.local/bin' "$HOME/.zprofile" 2>/dev/null; then
  printf '\n# added by your Caddy setup\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.zprofile"
fi

# 6. BASE global tier: config, the five hooks, the BASE section in ~/.claude/CLAUDE.md
# base install only wires hooks into a settings file that already exists, so make sure it does.
mkdir -p "$CLAUDE_DIR"
[[ -f "$CLAUDE_DIR/settings.json" ]] || echo '{}' > "$CLAUDE_DIR/settings.json"
hooks_wired() {
python3 - "$CLAUDE_DIR/settings.json" <<'PY'
import json, sys
try:
    s = json.load(open(sys.argv[1]))
except Exception:
    sys.exit(1)
events = {"SessionStart", "UserPromptSubmit", "PreToolUse", "PostToolUse", "Stop"}
found = set()
for ev, groups in (s.get("hooks") or {}).items():
    for g in groups:
        for h in g.get("hooks", []):
            if "base hook" in h.get("command", ""): found.add(ev)
sys.exit(0 if events <= found else 1)
PY
}
if [[ -f "$HOME/.base-gbl/manifest.toml" ]] && hooks_wired; then
  ok "BASE global tier already installed and hooked"
elif [[ -x "$BIN_DIR/base" ]] && "$BIN_DIR/base" install >/dev/null 2>&1 && hooks_wired; then
  ok "BASE installed (global tier, hooks, CLAUDE.md section)"
else
  fail "base install did not complete or did not wire its hooks"
fi

# 6b. Match the Caddy team's BASE settings: no per-response diagnostic block; memory mirrors to files too
CFG="$HOME/.base-gbl/base.toml"
if [[ -f "$CFG" ]]; then
python3 - "$CFG" <<'PY'
import re, sys
p = sys.argv[1]
lines = open(p, encoding="utf-8").read().split("\n")
section = None
out = []
for ln in lines:
    s = ln.strip()
    if s.startswith("[") and s.endswith("]"):
        section = s
    if section == "[devmode]" and re.match(r"^\s*enabled\s*=", ln):
        ln = re.sub(r"=\s*\S+", "= false", ln, count=1)
    if section == "[memory]" and re.match(r"^\s*mode\s*=", ln):
        ln = re.sub(r"=\s*\S+", '= "both"', ln, count=1)
    out.append(ln)
open(p, "w", encoding="utf-8").write("\n".join(out))
PY
  ok "BASE config matched to the Caddy team's settings"
fi

# 7. The frameworks, copied into place (the same layout the Caddy team runs)
F="$REPO/frameworks"; B="$REPO/base"
PAUL_CMDS="$F/paul/commands/paul"; [[ -d "$PAUL_CMDS" ]] || PAUL_CMDS="$F/paul/commands"
SEED_CMDS="$F/seed/commands/seed"; [[ -d "$SEED_CMDS" ]] || SEED_CMDS="$F/seed/commands"
SS_CMDS="$F/skillsmith/commands/skillsmith"; [[ -d "$SS_CMDS" ]] || SS_CMDS="$F/skillsmith/commands"
put "$PAUL_CMDS"              "$CLAUDE_DIR/commands/paul"       && ok "PAUL commands"
put "$F/paul/framework"       "$CLAUDE_DIR/paul-framework"      && ok "PAUL framework"
mkdir -p "$CLAUDE_DIR/agents"
for f in "$F"/paul/agents/paul-*.md; do [[ -f "$f" ]] && cp "$f" "$CLAUDE_DIR/agents/"; done
ok "PAUL agents (per file, your own agents untouched)"
put "$SEED_CMDS"              "$CLAUDE_DIR/commands/seed"       && ok "SEED commands"
put "$SS_CMDS"                "$CLAUDE_DIR/commands/skillsmith" && ok "Skillsmith commands"
put "$F/skillsmith/specs"     "$CLAUDE_DIR/skillsmith-specs"    && ok "Skillsmith specs"
put "$B/commands"             "$CLAUDE_DIR/commands/base"       && ok "BASE commands"
put "$B/skill"                "$CLAUDE_DIR/skills/base"         && ok "BASE skill"
put "$B/framework"            "$CLAUDE_DIR/base-framework"      && ok "BASE framework"

# 8. Workspace tier: this folder becomes a BASE workspace
cd "$REPO"
if [[ -f "$REPO/.base/base.toml" ]]; then
  ok "workspace tier already scaffolded"
elif "$BIN_DIR/base" scaffold >/dev/null 2>&1 && [[ -f "$REPO/.base/base.toml" ]]; then
  ok "workspace tier scaffolded (.base/)"
else
  fail "base scaffold did not create .base/"
fi

# 9. The BASE MCP server for this workspace (optional; needs node)
MCP_SRC="$B/framework/packages/base-mcp"
if command -v node >/dev/null 2>&1 && [[ -d "$MCP_SRC" ]]; then
  if [[ ! -d "$REPO/.base/base-mcp" ]]; then cp -R "$MCP_SRC" "$REPO/.base/base-mcp"; fi
  if [[ -d "$REPO/.base/base-mcp/node_modules/@modelcontextprotocol" ]] \
     || (cd "$REPO/.base/base-mcp" && npm install --omit=dev --silent >/dev/null 2>&1); then
    python3 - "$REPO" <<'PY'
import json, os, sys
repo = sys.argv[1]
p = os.path.join(repo, ".mcp.json")
cfg = {"mcpServers": {"base-mcp": {"command": "node", "args": [os.path.join(repo, ".base", "base-mcp", "index.js")]}}}
open(p, "w", encoding="utf-8").write(json.dumps(cfg, indent=2) + "\n")
PY
    ok "BASE MCP server wired for this workspace (.mcp.json)"
  else
    fail "BASE MCP server install failed (npm)"
  fi
else
  echo "skip  BASE MCP server (node not available)"
fi

# 10. Read-back verification
echo
echo "== Verification =="
[[ -x "$BIN_DIR/base" ]] && "$BIN_DIR/base" --version >/dev/null 2>&1 && ok "base --version answers" || fail "base does not run"
hooks_wired && ok "the five BASE hooks are wired in ~/.claude/settings.json" || fail "BASE hooks missing from ~/.claude/settings.json"
grep -qs "BASE CLI" "$CLAUDE_DIR/CLAUDE.md" && ok "BASE section present in ~/.claude/CLAUDE.md" || fail "BASE section missing from ~/.claude/CLAUDE.md"
[[ -f "$REPO/.mcp.json" ]] && grep -qs "base-mcp" "$REPO/.mcp.json" && ok ".mcp.json points at this workspace's BASE MCP server" || echo "skip  .mcp.json (no BASE MCP server)"
for d in commands/paul paul-framework commands/seed commands/skillsmith skillsmith-specs commands/base skills/base base-framework; do
  [[ -d "$CLAUDE_DIR/$d" ]] && ok "~/.claude/$d present" || fail "~/.claude/$d missing"
done
[[ -f "$REPO/.base/base.toml" ]] && ok ".base/ present in this folder" || fail ".base/ missing"

echo
echo "== Report =="
printf '%s\n' "${REPORT[@]}"
if [[ $FAIL -eq 0 ]]; then echo; echo "SETUP COMPLETE. Your Caddy's engine is in place."; else echo; echo "SETUP INCOMPLETE. Fix the FAIL lines above, then run /blueprint setup again."; fi
exit $FAIL
