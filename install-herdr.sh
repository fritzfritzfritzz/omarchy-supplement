#!/bin/bash

# Install herdr, a terminal workspace manager for AI coding agents.
# https://herdr.dev
#
# herdr is installed from its official installer, not from the AUR, so
# `omarchy update` will NOT keep it current. Update it with `herdr update`.
# Re-running this script also works: the installer overwrites the single
# binary at ~/.local/bin/herdr in place, it never installs a second copy.
#
# Uninstall with:
#   herdr integration uninstall claude   # and codex, pi
#   rm -rf ~/.claude/skills/herdr ~/.codex/skills/herdr \
#          ~/.pi/agent/skills/herdr ~/.local/bin/herdr

set -e

HERDR="$HOME/.local/bin/herdr"

if [[ -x "$HERDR" ]]; then
  echo "herdr is already installed, skipping download. Update it with: herdr update"
else
  curl -fsSL https://herdr.dev/install.sh | sh
fi

# Agents to wire up, as "<integration name>:<skills dir>". The integration
# reports each agent's lifecycle state (idle/working/blocked) back to herdr so
# the sidebar shows what every pane is doing; the skill teaches that agent it
# can drive herdr itself. Skipped for agents that aren't installed, so this
# stays usable on a machine that only has some of them.
AGENTS=(
  "claude:$HOME/.claude/skills"
  "codex:$HOME/.codex/skills"
  "pi:$HOME/.pi/agent/skills"
)

for entry in "${AGENTS[@]}"; do
  name="${entry%%:*}"
  skills_dir="${entry#*:}"

  if ! command -v "$name" &>/dev/null; then
    echo "$name is not installed, skipping its herdr integration."
    continue
  fi

  "$HERDR" integration install "$name"

  # herdr ships its own skill file, so regenerate it rather than vendoring a
  # copy: `herdr update` moves the CLI on its own schedule and a stale skill
  # would document commands that no longer exist. Re-running this resyncs it.
  mkdir -p "$skills_dir/herdr"
  "$HERDR" --skill >"$skills_dir/herdr/SKILL.md"
done
