#!/bin/sh

# --- Configuration ---
# 
BUILTIN_MONITOR_NAME="eDP-1" 
EXTERNAL_MONITOR_NAME="HDMI-A-1"
# ---------------------

# Function to handle Hyprland events
handle() {
    # $1: The entire event string (e.g., "monitoradded,HDMI-A-1,...")
    # echo "RAW HYPRLAND EVENT: $1"
    # # Split the event string into components (event, monitor name, etc.)
    EVENT_TYPE=$(echo "$1" | awk -F'>>' '{print $1}')
    MONITOR_NAME=$(echo "$1" | awk -F'>>' '{print $2}')
    #
    # # Simple logging to help with debugging
    echo "[$EVENT_TYPE] Event received for monitor: $MONITOR_NAME" >&2

    case $EVENT_TYPE in
        monitoradded)
            # Check if the added monitor is the external one
            if [ "$MONITOR_NAME" = "$EXTERNAL_MONITOR_NAME" ]; then
                echo "External monitor $EXTERNAL_MONITOR_NAME connected. Disabling built-in monitor $BUILTIN_MONITOR_NAME." >&2
                # Disable the built-in monitor
                # Note: 'disable' is a monitor keyword command for hyprctl
                hyprctl keyword monitor "$BUILTIN_MONITOR_NAME, disable"
            fi
            ;;
    #
        monitorremoved)
            # Check if the removed monitor is the external one
            if [ "$MONITOR_NAME" = "$EXTERNAL_MONITOR_NAME" ]; then
                echo "External monitor $EXTERNAL_MONITOR_NAME disconnected. Re-enabling built-in monitor $BUILTIN_MONITOR_NAME." >&2
                # Enable the built-in monitor using its 'preferred' resolution/refresh rate
                # and a scale of 1 (standard).
                hyprctl keyword monitor "$BUILTIN_MONITOR_NAME, preferred, auto, auto"
            fi
            ;;
    #
        *)
            # Ignore other events
            ;;
    esac
}

# -----------------
# Main Execution Loop
# -----------------
# The socat command connects to Hyprland's event socket (socket2.sock)
# and continuously pipes events to the 'handle' function.
# -U: Use UNIX-CONNECT for the UNIX socket.
# -: Use standard input/output (for piping).
socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | \
while read -r line; do
    handle "$line"
done
