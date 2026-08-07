#!/bin/bash

# Install Tailscale and enable its daemon.
#
# Arch never auto-enables systemd units, so installing the package alone leaves
# tailscaled stopped. `enable --now` starts it immediately and, because the unit
# is WantedBy=multi-user.target, brings it back on every boot. Both halves are
# idempotent, so rerunning this script is harmless and won't drop a live
# connection.
#
# Authenticating is deliberately left out: `sudo tailscale up` prints a URL and
# blocks until you log in via browser, which would stall install-all.sh.

set -e

yay -S --noconfirm --needed tailscale

sudo systemctl enable --now tailscaled

cat <<'EOF'

Tailscale installed, tailscaled enabled and running.

To connect this machine to your tailnet (one time, opens a browser):

    sudo tailscale up

Then verify with:

    tailscale status      # peers on your tailnet
    tailscale ip -4       # this machine's 100.x address

Note: node keys expire after ~180 days by default, and the machine drops off the
tailnet until you rerun `sudo tailscale up`. Disable key expiry for this device
in the Tailscale admin console if you want it permanently connected.
EOF
