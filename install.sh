#!/bin/bash

# Personal additions on top of a stock Omarchy 4 install.
# Everything goes through Omarchy's own installers, so it's safe to rerun.

set -e

omarchy install terminal ghostty
omarchy install ai chatgpt          # Codex desktop (openai-codex-desktop)
omarchy install dev-env bun
omarchy install dev-env rust
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

append_once() {
  grep -Fxq "$2" "$1" || printf '\n%s\n' "$2" >>"$1"
}

# Super+B: default browser, same as Omarchy's Super+Shift+B (unbound by default)
append_once ~/.config/hypr/bindings.lua 'o.bind("SUPER + B", "Browser", { omarchy = "browser" })'

# herdr prefix back to Ctrl+B (Omarchy's config uses Ctrl+Space to match its tmux)
sed -i 's/^prefix = "ctrl+space"$/prefix = "ctrl+b"/' ~/.config/herdr/config.toml

# Dotfiles only hold personal additions; Omarchy keeps owning the base files,
# which get one line appended to pull the additions in.
omarchy pkg add stow

if [[ ! -d ~/dotfiles ]]; then
  git clone git@github.com:fritzfritzfritzz/dotfiles.git ~/dotfiles
fi
stow --no-folding -d ~/dotfiles -t ~ bash ghostty

append_once ~/.bashrc 'source ~/.config/bash/personal.sh'
append_once ~/.config/ghostty/config 'config-file = ?personal.conf'

# LazyVim language extras live in lazyvim.json (the same list :LazyExtras edits)
LAZYVIM_JSON=~/.config/nvim/lazyvim.json
jq '.extras = (.extras + [
  "lazyvim.plugins.extras.lang.python",
  "lazyvim.plugins.extras.lang.typescript",
  "lazyvim.plugins.extras.lang.tailwind",
  "lazyvim.plugins.extras.lang.go",
  "lazyvim.plugins.extras.lang.docker",
  "lazyvim.plugins.extras.lang.rust"
] | unique)' "$LAZYVIM_JSON" >"$LAZYVIM_JSON.tmp" && mv "$LAZYVIM_JSON.tmp" "$LAZYVIM_JSON"
