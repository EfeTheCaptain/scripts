#!/bin/sh

# Prints the current volume or 🔇 if muted.

case $BLOCK_BUTTON in
    1) # Open alsamixer in the terminal
        setsid -w -f "$TERMINAL" -e alsamixer; pkill -RTMIN+10 "${STATUSBAR:-dwmblocks}" ;;
    2) # Toggle mute
        amixer set Master toggle; pkill -RTMIN+10 "${STATUSBAR:-dwmblocks}" ;;
    4) # Increase volume
        amixer set Master 1%+; pkill -RTMIN+10 "${STATUSBAR:-dwmblocks}" ;;
    5) # Decrease volume
        amixer set Master 1%-; pkill -RTMIN+10 "${STATUSBAR:-dwmblocks}" ;;
    3) # Show notification
        notify-send "📢 Volume module" "\- Shows volume 🔊, 🔇 if muted.
- Middle click to mute.
- Scroll to change." ;;
    6) # Edit this script with nvim in st terminal
        setsid -f "$TERMINAL" -e "$EDITOR" "$0" ;;
esac

# Get the current volume from alsamixer
vol="$(amixer get Master | grep -E -o '[0-9]*%' | head -n 1)"

# If muted, print 🔇 and exit.
if amixer get Master | grep -q '\[off\]'; then
    echo "🔇"
    pkill -RTMIN+10 "${STATUSBAR:-dwmblocks}"  # Refresh status bar when muted
    exit
fi

# Clean up the volume value (remove % sign)
vol="${vol%\%}"

# Set icons based on volume levels
case 1 in
    $((vol >= 70)) ) icon="🔊" ;;  # Loud
    $((vol >= 30)) ) icon="🔉" ;;  # Medium
    $((vol >= 1)) ) icon="🔈" ;;   # Quiet
    * ) icon="🔇" ;;        # Muted (though this case is already handled above)
esac

# Output the volume with the corresponding icon
echo "$icon$vol%"

# Force status bar refresh
pkill -RTMIN+10 "${STATUSBAR:-dwmblocks}"
