# NVIDIA SMI VRAM Widget

A tiny KDE Plasma 5 widget for Rocky Linux that shows NVIDIA GPU 0 VRAM usage as a circular percentage indicator.

It polls:

```bash
nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits -i 0
```

The center label shows the VRAM percentage. The Plasma tooltip shows the absolute `used MiB / total MiB` reading or the latest `nvidia-smi` error.

## Install

```bash
git clone https://github.com/JakeC95/nvidia-smi-widget.git
cd nvidia-smi-widget
bash scripts/install.sh
```

Then add `NVIDIA VRAM` from the Plasma widget picker.

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
