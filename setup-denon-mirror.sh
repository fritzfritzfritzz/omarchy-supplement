#!/bin/bash

# Machine-specific: a Denon AVR on HDMI with no screen attached, used only for
# audio. Mirroring the main display onto it keeps the HDMI link (and its audio)
# alive without it acting as a separate monitor that grabs workspaces.
# Disabling the output instead would cut HDMI audio too.
#
# Usage: ./setup-denon-mirror.sh [hdmi-output] [main-output]
# Find output names with: hyprctl monitors all

set -e

HDMI_OUTPUT="${1:-HDMI-A-1}"
MAIN_OUTPUT="${2:-DP-1}"
MONITORS=~/.config/hypr/monitors.lua
RULE="hl.monitor({ output = \"$HDMI_OUTPUT\", mode = \"preferred\", position = \"auto\", scale = 1, mirror = \"$MAIN_OUTPUT\" })"

if grep -Fxq "$RULE" "$MONITORS"; then
  echo "$HDMI_OUTPUT already mirrors $MAIN_OUTPUT"
else
  printf '\n-- Denon AVR on HDMI: audio only, mirror the main display\n%s\n' "$RULE" >>"$MONITORS"
  echo "Added mirror rule for $HDMI_OUTPUT to $MONITORS"
fi

hyprctl reload >/dev/null
hyprctl configerrors
