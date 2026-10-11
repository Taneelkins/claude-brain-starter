#!/usr/bin/env bash
# Installs the tools and packages this game needs. Safe to re-run.
set -euo pipefail
cd "$(dirname "$0")"

command -v rokit >/dev/null || { echo "Install Rokit first: https://github.com/rojo-rbx/rokit"; exit 1; }
rokit install
wally install

# Packet isn't on Wally, so pull it from its source mirror
Dest=src/shared/Vendor/Packet
if [ ! -f "$Dest/init.luau" ]; then
  Base=https://raw.githubusercontent.com/mrchigurh/Suphi-Packet/main/Packet
  for File in init Signal Task Types/init Types/Characters Types/Enums Types/Static1 Types/Static2 Types/Static3; do
    mkdir -p "$Dest/$(dirname "$File")"
    curl -fsSL "$Base/$File.lua" -o "$Dest/$File.luau"
  done
  echo "Downloaded Packet"
fi

rojo sourcemap default.project.json -o sourcemap.json
echo "Ready. Run: rojo serve"
