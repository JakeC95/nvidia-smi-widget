# Project Knowledge

## Verified Environment

- Target workstation: `ws62`.
- Target desktop: Rocky Linux with KDE Plasma 5.27.11.
- Target package type: Plasma 5 applet installed with `kpackagetool5`.
- Widget id: `com.github.jakec95.nvidia-smi-vram`.
- Remote checkout path used by the bridge deploy helper: `/home/JAMM/jakec/nvidia-smi-widget`.

## Runtime Behavior

- Polls GPU 0 every 5 seconds with:

  ```bash
  nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits -i 0
  ```

- Displays the VRAM percentage in the center of a circular panel indicator.
- Uses NVIDIA green `#76B900` for the active ring and a thicker stroke than the first implementation.
- Uses a polling guard so overlapping `nvidia-smi` executable requests are not started if a previous request has not returned.

## Plasma Edit-Mode Stability

- The Canvas-based implementation could make Plasma crash/restart when right-clicking the panel to enter edit mode or rearrange widgets.
- The fix was commit `9caa98c` (`Stabilize widget edit mode rendering`):
  - Replaced `Canvas` painting with declarative `QtQuick.Shapes` and `PathAngleArc`.
  - Removed the full-widget `PlasmaCore.ToolTipArea` overlay.
  - Replaced invalid unbounded maximum layout values with bounded desktop values.
  - Kept the NVIDIA green, thicker ring style.
- Jake verified after deployment that right-click/edit mode no longer crashes KDE.

## Deployment Loop

- Source repo: `https://github.com/JakeC95/nvidia-smi-widget`.
- Remote deploy is performed through the Deadline Monitor command bridge using:

  ```bash
  python3 /home/JAMM/jakec/houdinivx20.0/scripts/python/deadline_monitor_repo/scripts/deploy_nvidia_smi_widget.py https://github.com/JakeC95/nvidia-smi-widget.git main
  ```

- The helper fetches `main`, runs `bash scripts/test.sh` on Rocky, installs with `bash scripts/install.sh`, confirms the applet appears in `kpackagetool5 --type Plasma/Applet --list`, and attempts a Plasma shell reload.
- `kstart5 plasmashell` may time out because `plasmashell` remains attached as a running process. Treat this as non-fatal when the deploy JSON reports `installed: true` and `status: "OK"`.

## Maintenance Rules

- Keep UI rendering declarative where possible. Do not reintroduce `Canvas` without retesting Plasma right-click/edit mode on `ws62`.
- Avoid full-widget pointer/event overlays; let Plasma own right-click and edit-mode gestures.
- Keep package tests checking for `QtQuick.Shapes`, `PathAngleArc`, and absence of `Canvas`.
