#!/usr/bin/env bash
set -euo pipefail

PLUGIN_ID="com.github.jakec95.nvidia-smi-vram"

if ! command -v kpackagetool5 >/dev/null 2>&1; then
    echo "ERROR: kpackagetool5 is required for Plasma 5 widget removal." >&2
    exit 1
fi

kpackagetool5 --type Plasma/Applet --remove "$PLUGIN_ID"
echo "Removed $PLUGIN_ID"
