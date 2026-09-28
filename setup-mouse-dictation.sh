#!/bin/bash

# Machine-specific: dictation on the hs6209 wireless mouse's side buttons.
# Button 276 toggles dictation, holding 275 is push-to-talk. Same voxtype
# commands as Omarchy's Super+Ctrl+X and F9.
#
# To find other button numbers, bind a candidate to notify-send in
# bindings.lua, or run `wev` (a button that sends a key combo shows up there
# as keys, not a button).

set -e

BINDINGS=~/.config/hypr/bindings.lua

append_once() {
  grep -Fxq "$1" "$BINDINGS" || printf '%s\n' "$1" >>"$BINDINGS"
}

if ! grep -q '^o.bind("mouse:27[56]"' "$BINDINGS"; then
  printf '\n-- Mouse dictation: 276 toggles, holding 275 is push-to-talk\n' >>"$BINDINGS"
fi

append_once 'o.bind("mouse:276", "Toggle dictation", "voxtype record toggle")'
append_once 'o.bind("mouse:275", "Start dictation (push-to-talk)", "voxtype record start")'
append_once 'o.bind("mouse:275", "Stop dictation (push-to-talk)", "voxtype record stop", { release = true })'

hyprctl reload >/dev/null
hyprctl configerrors
