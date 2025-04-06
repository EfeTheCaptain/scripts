#!/bin/sh

# Cached data file
cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/prayertimes"
data_fetch_command="python3 /home/efe/.local/bin/scripts/prayer-times.py"
icon=""

fetch_data() {
    $data_fetch_command > "$cache_file" || exit 1
}

check_cache() {
    [ -s "$cache_file" ] && [ "$(($(date +%s) - $(stat -c %Y "$cache_file")))" -lt 21600 ]
}

read_cache() {
    cat "$cache_file"
}

check_cache || fetch_data

cache_date=$(date -d "@$(stat -c %Y "$cache_file")" +"Last updated at: %H:%M, %B %d")

case $BLOCK_BUTTON in
    1) notify-send "İstanbul Namaz Vakitleri" "$(printf "%s\n\n%s" "$cache_date" "$(read_cache)")" ;;
    2) fetch_data ;;
    3) notify-send "ℹ️ Prayer Times Module" "Left-click: Show notification\nMiddle-click: Refresh\nRight-click: Info" ;;
    6) st -e nvim "$0" ;;
esac

echo "$icon"
