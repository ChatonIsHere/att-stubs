#!/usr/bin/env bash
# Usage: ./make-stubs.sh <game dir>
# Needs refasmer and assembly-publicizer on PATH:
#   dotnet tool install -g JetBrains.Refasmer.CliTool --version 2.0.3
#   dotnet tool install -g BepInEx.AssemblyPublicizer.Cli --version 0.4.3
set -euo pipefail
GAME=$1
OUT=$(cd "$(dirname "$0")" && pwd)
M="A Township Tale_Data/Managed"
ML="MelonLoader/net35"
PUBLIC="Alta.Analytics.Runtime Alta.Api.Client Alta.Api.DataTransferModels Alta.Authentication
  Alta.CommandLine Alta.Core.Runtime Alta.Global.Runtime Alta.IO Alta.NetworkTransport.Runtime Alta.Platform
  Alta.Platform.Generic Alta.Serialization.Runtime Alta.Singletons Alta.Timing.Runtime Alta.Values kcp2k
  NLog Newtonsoft.Json Unity.InputSystem UnityEngine UnityEngine.CoreModule UnityEngine.IMGUIModule"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$OUT/$M" "$OUT/$ML"

files=()
for a in $PUBLIC; do files+=("$GAME/$M/$a.dll"); done
refasmer -c --omit-non-api-members=true -O "$OUT/$M" "${files[@]}" </dev/null
refasmer -c --omit-non-api-members=true -O "$OUT/$ML" "$GAME/$ML/MelonLoader.dll" "$GAME/$ML/0Harmony.dll" </dev/null

# Mods use Root.Township's private members, so keep them all and make them public.
refasmer --all -O "$tmp" "$GAME/$M/Root.Township.dll" </dev/null
assembly-publicizer "$tmp/Root.Township.dll" -o "$tmp/pub" </dev/null
mv "$tmp/pub/Root.Township-publicized.dll" "$OUT/$M/Root.Township.dll"
