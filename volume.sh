#!/bin/sh

# Prints the current volume or 󰖁 if muted.

case $BLOCK_BUTTON in
    1) # Open alsamixer in the terminal
        st -e alsamixer; pkill -RTMIN+10  ;;
    2) # Toggle mute
        amixer -q set Master toggle; pkill -RTMIN+10  ;;
    4) # Increase volume
        amixer -q set Master 2%+; pkill -RTMIN+10  ;;
    5) # Decrease volume
        amixer -q set Master 3%-; pkill -RTMIN+10  ;;
    6) # Edit this script with nvim in st terminal
        st -e nvim "$0" ;;
esac

# Get the current volume from alsamixer
vol="$(amixer get Master | grep -E -o '[0-9]*%' | head -n 1)"

# Clean up the volume value (remove % sign)
vol="${vol%\%}"

# If muted, print 󰖁 and exit.
if amixer get Master | grep -q '\[off\]'; then
    echo "󰖁"
    pkill -RTMIN+10 "${STATUSBAR:-dwmblocks}"  # Refresh status bar when muted
    exit
fi
# Set icons based on volume levels
case 1 in
    $((vol >= 70)) ) icon="󰕾" ;;  # Loud
    $((vol >= 30)) ) icon="󰖀" ;;  # Medium
    $((vol >= 1)) ) icon="󰕿" ;;   # Quiet
    * ) icon="󰖁" ;;        # Muted (though this case is already handled above)
esac

# Output the volume with the corresponding icon
echo "$icon$vol%"

# Force status bar refresh
pkill -RTMIN+10 "${STATUSBAR:-dwmblocks}"
