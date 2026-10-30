#!/usr/bin/env bash
# Usage: ./make-stubs.sh <game dir>
# Stubs every assembly in Managed/ and MelonLoader/net35/, so this repo builds
# anything the game folder would.
# Needs refasmer and assembly-publicizer on PATH:
#   dotnet tool install -g JetBrains.Refasmer.CliTool --version 2.0.3
#   dotnet tool install -g BepInEx.AssemblyPublicizer.Cli --version 0.4.3
set -euo pipefail
GAME=$1
OUT=$(cd "$(dirname "$0")" && pwd)
M="A Township Tale_Data/Managed"
ML="MelonLoader/net35"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
rm -rf "$OUT/$M" "$OUT/$ML"
mkdir -p "$OUT/$M" "$OUT/$ML"

files=()
for f in "$GAME/$M"/*.dll; do
  [ "$(basename "$f")" = Root.Township.dll ] || files+=("$f")
done
refasmer -c --omit-non-api-members=true -O "$OUT/$M" "${files[@]}" </dev/null
refasmer -c --omit-non-api-members=true -O "$OUT/$ML" "$GAME/$ML"/*.dll </dev/null

# Mods use Root.Township's private members, so keep them all and make them public.
refasmer --all -O "$tmp" "$GAME/$M/Root.Township.dll" </dev/null
assembly-publicizer "$tmp/Root.Township.dll" -o "$tmp/pub" </dev/null
mv "$tmp/pub/Root.Township-publicized.dll" "$OUT/$M/Root.Township.dll"

# Anything refasmer couldn't stub is listed, not copied: these files hold no game code.
missing=0
for f in "$GAME/$M"/*.dll "$GAME/$ML"/*.dll; do
  rel=${f#"$GAME/"}
  [ -f "$OUT/$rel" ] || { echo "not stubbed: $rel" >&2; missing=1; }
done
exit $missing
