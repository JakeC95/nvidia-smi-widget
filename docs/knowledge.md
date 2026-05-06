# Development Notes

## Supported Environment

- Target desktop: KDE Plasma 5.
- Target package type: Plasma 5 applet installed with `kpackagetool5`.
- Widget id: `com.github.jakec95.nvidia-smi-vram`.
- End-user install path is public GitHub clone or copied repo archive, followed by `bash scripts/install.sh`.
- Users add it from Plasma's widget picker as `NVIDIA VRAM`.

## Runtime Behavior

- Polls GPU 0 every 5 seconds with:

  ```bash
  nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits -i 0
  ```

- Displays the VRAM percentage in the center of a circular panel indicator.
- Uses NVIDIA green `#76B900` for the active ring and a thicker stroke than the first implementation.
- Uses a polling guard so overlapping `nvidia-smi` executable requests are not started if a previous request has not returned.
- Exposes Plasma settings for ring color, poll interval, rounded-vs-decimal percentage display, and percentage text scale.

## Plasma Edit-Mode Stability

- Earlier Canvas-based rendering could destabilize Plasma edit mode on some systems when right-clicking the panel or rearranging widgets.
- The fix was commit `9caa98c` (`Stabilize widget edit mode rendering`):
  - Replaced `Canvas` painting with declarative `QtQuick.Shapes` and `PathAngleArc`.
  - Removed the full-widget pointer overlay.
  - Replaced invalid unbounded maximum layout values with bounded desktop values.
  - Kept the NVIDIA green, thicker ring style.

## Maintenance Rules

- Keep UI rendering declarative where possible. Do not reintroduce `Canvas` without retesting Plasma right-click/edit mode.
- Avoid full-widget pointer/event overlays; let Plasma own right-click and edit-mode gestures.
- Keep package tests checking for `QtQuick.Shapes`, `PathAngleArc`, and absence of `Canvas`.
- Keep public docs free of workstation names, internal paths, and private deployment details.
