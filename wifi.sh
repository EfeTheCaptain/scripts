#!/bin/sh

# Get the signal strength (RSSI) using sudo iw
signal=$(sudo iw dev wlan0 link | grep -i signal | awk '{print $2}')

# Check if connected
if [ -z "$signal" ]; then
    icon="󰤮"  # No connection (Network Off)
else
    # Convert RSSI (-30 dBm best, -100 dBm worst) to percentage
    quality=$(( (signal + 100) * 100 / 70 ))

    # Choose WiFi strength icon
    if [ "$quality" -le 10 ]; then
        icon="󰤠"  # Weakest signal
    elif [ "$quality" -le 25 ]; then
        icon="󰤢"  # 2 bars
    elif [ "$quality" -le 50 ]; then
        icon="󰤥"  # 3 bars
    elif [ "$quality" -le 70 ]; then
        icon="󰖩"  # 4 bars
    else
        icon="󰖩"  # Strongest signal
    fi

fi

# Click actions
case $BLOCK_BUTTON in
    1) notify-send "📶 WiFi Signal Info" "$(sudo iw dev wlan0 link)" ;;
    6) st -e nvim "$0" ;;
esac

# Print the final icon only
echo "$icon "
