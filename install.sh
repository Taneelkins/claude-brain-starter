#!/usr/bin/env bash
# Sets up the Claude Brain: copies the starter vault, downloads its Obsidian plugins,
# installs the slash commands and links the global Claude rules.
# Safe to re-run: it never overwrites notes in an existing vault.
#
#   ./install.sh                         # vault at ~/Documents/Claude Brain
#   VAULT=~/Notes/Brain ./install.sh     # somewhere else
#   NAME=Sam ./install.sh                # skip the name prompt
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
  { fill < "$Src"; printf '\n%s\n' "$Marker"; } > "$Dest"
done
say "Installed commands: /brain /save /brain-audit /new-project"

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

cat <<EOF

Done. Next:
  1. Open Obsidian -> "Open folder as vault" -> $Vault
  2. When it asks, click "Trust author and enable plugins".
  3. Start Claude Code anywhere and type:  /new-project <your project>
EOF
