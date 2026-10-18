#!/usr/bin/env bash
# Sets up the Claude Brain: copies the starter vault, downloads its Obsidian plugins,
# installs the slash commands and links the global Claude rules.
# Safe to re-run: it never overwrites notes in an existing vault.
#
#   ./install.sh                         # vault at ~/Documents/Claude Brain
#   VAULT=~/Notes/Brain ./install.sh     # somewhere else
#   NAME=Sam ./install.sh                # skip the name prompt
#   ROBLOX=yes ./install.sh              # also set up the Roblox tools without asking (ROBLOX=no to skip)
#   MULTI=yes ./install.sh               # also set up the many-chats tools without asking (MULTI=no to skip)
set -euo pipefail

Repo="$(cd "$(dirname "$0")" && pwd)"
Vault="${VAULT:-$HOME/Documents/Claude Brain}"
Claude="$HOME/.claude"
Marker="<!-- brain-starter -->"

Plugins=(
  "waypoint IdreesInc/Waypoint"
  "folder-notes LostPaul/obsidian-folder-notes"
  "omnisearch scambier/obsidian-omnisearch"
  "tag-wrangler pjeby/tag-wrangler"
)

say() { printf '\033[1m%s\033[0m\n' "$*"; }
warn() { printf '\033[33m%s\033[0m\n' "$*"; }
fill() { NAME="$Name" VAULT="$Vault" perl -pe 's/\{\{NAME\}\}/$ENV{NAME}/g; s/\{\{VAULT\}\}/$ENV{VAULT}/g'; }

Name="${NAME:-}"
if [ -z "$Name" ]; then
  read -rp "Your first name (Claude will call you this): " Name || true
fi
Name="${Name:-the user}"

# 1. Vault
if [ -d "$Vault" ]; then
  say "Vault already exists at $Vault, leaving your notes alone."
else
  say "Creating vault at $Vault"
  mkdir -p "$Vault"
  cp -R "$Repo/vault/." "$Vault/"
  find "$Vault" -name '*.md' -not -path '*/_templates/*' -print0 | while IFS= read -r -d '' f; do
    fill < "$f" > "$f.tmp" && mv "$f.tmp" "$f"
  done
fi

# 2. Obsidian plugins (downloaded from each plugin's latest GitHub release)
for Entry in "${Plugins[@]}"; do
  read -r Id Source <<< "$Entry"
  Dir="$Vault/.obsidian/plugins/$Id"
  mkdir -p "$Dir"
  if [ -f "$Dir/main.js" ] && [ "${1:-}" != "--update" ]; then
    continue
  fi
  say "Downloading plugin: $Id"
  for File in main.js manifest.json styles.css; do
    curl -fsSL "https://github.com/$Source/releases/latest/download/$File" -o "$Dir/$File" 2>/dev/null \
      || { rm -f "$Dir/$File"; [ "$File" = styles.css ] || { echo "  failed to fetch $File for $Id"; exit 1; }; }
  done
done

# 3. Slash commands
mkdir -p "$Claude/commands"
for Src in "$Repo"/claude/commands/*.md; do
  Dest="$Claude/commands/$(basename "$Src")"
  if [ -f "$Dest" ] && ! grep -qF "$Marker" "$Dest"; then
    mv "$Dest" "$Dest.bak"
    say "Backed up your existing $(basename "$Dest") to $(basename "$Dest").bak"
  fi
  { fill < "$Src" | REPO="$Repo" perl -pe 's/\{\{REPO\}\}/$ENV{REPO}/g'; printf '\n%s\n' "$Marker"; } > "$Dest"
done
say "Installed commands: /brain /save /brain-audit /new-project /new-game"

# 4. Global rules: ~/.claude/CLAUDE.md -> the vault's Claude Rules note
Rules="$Vault/Playbook/Claude Rules.md"
if [ -L "$Claude/CLAUDE.md" ] && [ "$(readlink "$Claude/CLAUDE.md")" = "$Rules" ]; then
  :
elif [ -e "$Claude/CLAUDE.md" ]; then
  say "You already have ~/.claude/CLAUDE.md, so it was NOT replaced."
  echo "  Copy your old rules into: $Rules"
  echo "  Then run:  ln -sf \"$Rules\" ~/.claude/CLAUDE.md"
else
  ln -s "$Rules" "$Claude/CLAUDE.md"
  say "Linked ~/.claude/CLAUDE.md -> Claude Rules.md"
fi

# 5. Roblox tools: Roblox's built-in Studio MCP (main Studio tool), upload bridge (uploads + Blender export), Blender MCP
Roblox="${ROBLOX:-ask}"
if [ "$Roblox" = ask ]; then
  read -rp "Set up the Roblox tools too (Studio bridge + Blender MCP)? [Y/n] " Answer || true
  case "${Answer:-y}" in [Nn]*) Roblox=no ;; *) Roblox=yes ;; esac
fi
if [ "$Roblox" = yes ]; then
  Bridge="$HOME/claude-studio-bridge"   # never under ~/Documents: macOS blocks the background daemon there
  if ! command -v node >/dev/null; then
    warn "Node.js 22+ is needed for the Studio bridge: https://nodejs.org (then re-run this script)"
  else
    if [ -d "$Bridge/.git" ]; then
      git -C "$Bridge" pull --ff-only -q || warn "Couldn't update $Bridge (local changes?), using it as is"
    else
      say "Cloning the Studio bridge to $Bridge"
      git clone -q https://github.com/Taneelkins/claude-studio-bridge "$Bridge"
    fi
    say "Building the Studio bridge"
    (cd "$Bridge/bridge" && npm install --silent && npm run build --silent)
    if [ "$(uname)" = Darwin ]; then
      mkdir -p "$HOME/Documents/Roblox/Plugins"
      cp "$Bridge/release/TaruTools.rbxm" "$HOME/Documents/Roblox/Plugins/"
      node "$Bridge/scripts/register-mcp.mjs"
      "$Bridge/scripts/install-daemon.sh" || warn "Daemon install failed; the bridge still works while a Claude chat is open"
    else
      warn "Studio only runs on Mac/Windows. On Windows run: powershell -ExecutionPolicy Bypass -File $Bridge/scripts/install.ps1"
    fi
  fi

  StudioMcp="/Applications/RobloxStudio.app/Contents/MacOS/StudioMCP"
  if [ -x "$StudioMcp" ] && command -v claude >/dev/null; then
    claude mcp get Roblox_Studio >/dev/null 2>&1 || claude mcp add Roblox_Studio -s user -- "$StudioMcp"
    say "Studio MCP registered. In Studio: Assistant -> ... -> Settings -> MCP Servers -> enable"
  else
    warn "Register Roblox's Studio MCP yourself: claude mcp add Roblox_Studio -s user -- <path to StudioMCP>, then enable it in Studio (Assistant -> Settings -> MCP Servers)"
  fi

  if ! command -v uvx >/dev/null; then
    warn "Blender MCP needs uv: brew install uv  (or https://docs.astral.sh/uv/), then re-run this script"
  elif ! command -v claude >/dev/null; then
    warn "Claude Code CLI not found, so the Blender MCP wasn't registered"
  else
    if ! claude mcp get blender >/dev/null 2>&1; then
      claude mcp add blender -s user -e DISABLE_TELEMETRY=true -- uvx mcp-for-blender@2.1.9
    fi
    uvx mcp-for-blender@2.1.9 install-addon || warn "Couldn't install the Blender add-on (is Blender installed?). Re-run later: uvx mcp-for-blender@2.1.9 install-addon"
    say "Blender MCP ready"
  fi

  command -v rokit >/dev/null || warn "For new games, install Rokit: https://github.com/rojo-rbx/rokit"
fi

# 6. Many chats at once: claude-lock, 6 Blender slots behind one shared server, playtest + long-chat guard hooks
Multi="${MULTI:-ask}"
if [ "$Multi" = ask ]; then
  read -rp "Set up the tools for running several chats at once (locks, 6 Blender slots, guard hooks)? [y/N] " Answer || true
  case "${Answer:-n}" in [Yy]*) Multi=yes ;; *) Multi=no ;; esac
fi
if [ "$Multi" = yes ]; then
  Tools="$HOME/claude-tools"   # outside ~/Documents so the background service may run it
  mkdir -p "$Tools"
  cp "$Repo"/tools/multi/* "$Tools/" && chmod +x "$Tools"/*
  say "Copied claude-lock, blender-slot and the guard hooks to $Tools"

  if [ "$(uname)" = Darwin ] && command -v uvx >/dev/null && command -v claude >/dev/null; then
    Agent="$HOME/Library/LaunchAgents/com.claude-brain.blender-bridge.plist"
    mkdir -p "$(dirname "$Agent")"
    cat > "$Agent" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.claude-brain.blender-bridge</string>
  <key>ProgramArguments</key><array><string>$Tools/blender-bridge</string></array>
  <key>RunAtLoad</key><true/>
  <key>KeepAlive</key><true/>
  <key>ThrottleInterval</key><integer>10</integer>
  <key>StandardOutPath</key><string>$Tools/blender-bridge.log</string>
  <key>StandardErrorPath</key><string>$Tools/blender-bridge.log</string>
</dict>
</plist>
PLIST
    launchctl bootout "gui/$(id -u)" "$Agent" 2>/dev/null || true
    launchctl bootstrap "gui/$(id -u)" "$Agent" || warn "Couldn't start the Blender bridge service; run: launchctl bootstrap gui/$(id -u) \"$Agent\""
    for Slot in blender blender2 blender3 blender4 blender5 blender6; do
      if claude mcp get "$Slot" 2>/dev/null | grep -q "Type: stdio"; then
        claude mcp remove "$Slot" -s user >/dev/null 2>&1 || true
      fi
      claude mcp get "$Slot" >/dev/null 2>&1 || claude mcp add --transport http "$Slot" -s user "http://127.0.0.1:9870/servers/$Slot/mcp" >/dev/null
    done
    say "Blender slots blender..blender6 now share one server (check: curl -s 127.0.0.1:9870/status)"
  else
    warn "The shared Blender server is Mac-only for now (needs uv and the Claude CLI); keeping the single 'blender' server"
  fi

  if [ "$(uname)" = Darwin ]; then
    TOOLS="$Tools" python3 - <<'PY'
import json, os
Path = os.path.expanduser("~/.claude/settings.json")
Tools = os.environ["TOOLS"]
Data = json.load(open(Path)) if os.path.exists(Path) else {}
Hooks = Data.setdefault("hooks", {})
def Add(Event, Command, Matcher=None):
    Entries = Hooks.setdefault(Event, [])
    if any(h.get("command") == Command for e in Entries for h in e.get("hooks", [])):
        return
    Entry = {"hooks": [{"type": "command", "command": Command}]}
    if Matcher:
        Entry["matcher"] = Matcher
    Entries.append(Entry)
Add("PreToolUse", Tools + "/play-guard", "mcp__Roblox_Studio__start_stop_play")
Add("Stop", Tools + "/context-guard")
json.dump(Data, open(Path, "w"), indent=2)
PY
    say "Added the playtest guard and long-chat guard hooks to ~/.claude/settings.json"
  fi
fi

cat <<EOF

Done. Next:
  1. Open Obsidian -> "Open folder as vault" -> $Vault
  2. When it asks, click "Trust author and enable plugins".
  3. Restart Claude Code (and Roblox Studio) so the new tools load.
  4. In Claude Code:  /new-game <name>   (or /new-project for anything that isn't a Roblox game)
  5. Running several chats at once? Read Roblox/Running Many Chats in the vault.
EOF
