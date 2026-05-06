# NVIDIA SMI VRAM Widget

A tiny KDE Plasma 5 widget that shows NVIDIA GPU 0 VRAM usage as a circular percentage indicator.

It polls:

```bash
nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits -i 0
```

The center label shows the VRAM percentage. The ring uses NVIDIA green (`#76B900`) so it is visually distinct from the default blue used by many system monitor widgets.

The widget renders the ring with `QtQuick.Shapes` instead of a manual canvas repaint loop, which keeps it lightweight and friendly to Plasma's normal panel edit mode.

## Install

On another Rocky Linux/KDE machine, install from GitHub:

```bash
git clone https://github.com/JakeC95/nvidia-smi-widget.git
cd nvidia-smi-widget
bash scripts/install.sh
```

Then add the widget:

1. Right-click the panel or desktop.
2. Choose **Add Widgets**.
3. Search for **NVIDIA VRAM**.
4. Add it to the panel.

If the machine cannot access GitHub, download or copy this repository as a zip/tar folder, extract it, then run:

```bash
cd nvidia-smi-widget
bash scripts/install.sh
```

To update an existing install:

```bash
cd nvidia-smi-widget
git pull
bash scripts/install.sh
```

## Configure

Right-click the widget and open its settings to change:

- Ring color, as a hex color such as `#76B900`
- Poll interval, from 1 second to 3600 seconds
- Percentage display, either one decimal place or rounded to the nearest whole number
- Percentage text size, from `1.0x` to `1.5x`; the default is `1.25x`

If Plasma does not refresh the widget list immediately:

```bash
kquitapp5 plasmashell && kstart5 plasmashell
```

## Test

```bash
bash scripts/test.sh
```

The package test validates the Plasma package layout and, when available, checks that `nvidia-smi` can return GPU 0 memory values.

## Uninstall

```bash
bash scripts/uninstall.sh
```

## Notes

- Target desktop: KDE Plasma 5.
- Target GPU: GPU 0.
- Refresh interval: 5 seconds.
- Runtime dependencies: Plasma 5, `kpackagetool5` for install, and NVIDIA's `nvidia-smi`.
