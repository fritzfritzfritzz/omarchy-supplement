#!/bin/bash

# Personal additions on top of a stock Omarchy 4 install.
# Everything goes through Omarchy's own installers, so it's safe to rerun.

set -e

omarchy install terminal ghostty
omarchy install ai chatgpt          # Codex desktop (openai-codex-desktop)
omarchy install dev-env bun
omarchy install service tailscale   # interactive: opens a browser login

# herdr: report agent state (idle/working/blocked) to the sidebar and teach
# each agent it can drive herdr. claude, codex and pi are Omarchy's mise
# launchers in ~/.local/bin, so they're always present. Rerun after
# `herdr update` to resync the skill.
declare -A SKILL_DIRS=(
  [claude]="$HOME/.claude/skills"
  [codex]="$HOME/.codex/skills"
  [pi]="$HOME/.pi/agent/skills"
)

for agent in "${!SKILL_DIRS[@]}"; do
  herdr integration install "$agent"
  mkdir -p "${SKILL_DIRS[$agent]}/herdr"
  herdr --skill >"${SKILL_DIRS[$agent]}/herdr/SKILL.md"
done

# Super+B: default browser, same as Omarchy's Super+Shift+B (unbound by default)
BINDINGS="$HOME/.config/hypr/bindings.lua"
BROWSER_BIND='o.bind("SUPER + B", "Browser", { omarchy = "browser" })'

if ! grep -Fxq "$BROWSER_BIND" "$BINDINGS"; then
  printf '\n%s\n' "$BROWSER_BIND" >>"$BINDINGS"
fi
