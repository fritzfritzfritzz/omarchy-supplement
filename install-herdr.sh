#!/bin/bash

# Install herdr, a terminal workspace manager for AI coding agents.
# https://herdr.dev
#
# herdr is installed from its official installer, not from the AUR, so
# `omarchy update` will NOT keep it current. Update it with `herdr update`.
# Re-running this script also works: the installer overwrites the single
# binary at ~/.local/bin/herdr in place, it never installs a second copy.
#
# Uninstall with: rm ~/.local/bin/herdr

set -e

curl -fsSL https://herdr.dev/install.sh | sh
