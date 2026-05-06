#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

required=(
    "$ROOT/metadata.json"
    "$ROOT/metadata.desktop"
    "$ROOT/contents/ui/main.qml"
)

for path in "${required[@]}"; do
    if [ ! -f "$path" ]; then
        echo "Missing required file: $path" >&2
        exit 1
    fi
done

grep -q "X-KDE-PluginInfo-Name=com.github.jakec95.nvidia-smi-vram" "$ROOT/metadata.desktop"
grep -q "X-Plasma-MainScript=ui/main.qml" "$ROOT/metadata.desktop"
grep -q '"Id": "com.github.jakec95.nvidia-smi-vram"' "$ROOT/metadata.json"
grep -q '"ExternalScripts"' "$ROOT/metadata.json"
python3 -m json.tool "$ROOT/metadata.json" >/dev/null
grep -q "nvidia-smi --query-gpu=memory.used,memory.total" "$ROOT/contents/ui/main.qml"
grep -q "interval: 5000" "$ROOT/contents/ui/main.qml"

if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits -i 0 >/dev/null
fi

echo "Widget package checks passed"
