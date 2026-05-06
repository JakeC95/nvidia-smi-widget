#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN_ID="com.github.jakec95.nvidia-smi-vram"

if ! command -v kpackagetool5 >/dev/null 2>&1; then
    echo "ERROR: kpackagetool5 is required for Plasma 5 widget installation." >&2
    exit 1
fi

bash "$ROOT/scripts/test.sh"

kpackagetool5 --type Plasma/Applet --remove "$PLUGIN_ID" >/dev/null 2>&1 || true
kpackagetool5 --type Plasma/Applet --install "$ROOT"

echo "Installed $PLUGIN_ID"
echo "Add it from Plasma's widget picker: NVIDIA VRAM"
echo "If it does not appear immediately, run: kquitapp5 plasmashell && kstart5 plasmashell"
