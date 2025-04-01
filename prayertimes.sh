#!/bin/sh

# Cached data file
cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/prayettimes"
data_fetch_command="python3 /home/efe/.local/bin/scripts/prayer-times.py"  # Modify this with your actual script
icon=""  # The only thing visible in dwmblocks

# Function to fetch and save data
fetch_data() {
    $data_fetch_command > "$cache_file" || exit 1
}

# Check if cache is older than 6 hours (21600 seconds)
check_cache() {
    [ -s "$cache_file" ] && [ "$(($(date +%s) - $(stat -c %Y "$cache_file")))" -lt 21600 ]
}

# Read cached data
read_cache() {
    cat "$cache_file"
}
# Fetch data if cache is too old
check_cache || fetch_data

cache_date=$(date -d "@$(stat -c %Y "$cache_file")" +"Last updated at: \(%H:%M\) %B %d\n")


# Handle click actions
case $BLOCK_BUTTON in
	1) notify-send "İstanbul Namaz Vakitleri:" "$cache_date\n$(read_cache)" ;;  # Show notification
	2) fetch_data ;;                                    # Refresh cache manually
	3) notify-send "ℹ️ Data Module" "Left-click: Show notification\nMiddle-click: Refresh" ;;
	6) st -e nvim "$0" ;;      # Edit script
esac

# Only display the icon in dwmblocks
echo "$icon"
