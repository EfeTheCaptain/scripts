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

get_remaining_time() {
    # Get current prayer times from cache
    prayer_times=$(grep -E '^(İmsak|Güneş|Öğle|İkindi|Akşam|Yatsı):' "$cache_file")
    
    # Get current time
    now=$(date +%H:%M)
    now_sec=$(date -d "$now" +%s)
    
    # Find next prayer time
    while IFS= read -r line; do
        prayer_name=$(echo "$line" | cut -d: -f1)
        prayer_time=$(echo "$line" | awk '{print $2}')
        prayer_sec=$(date -d "$prayer_time" +%s)
        
        if [ "$prayer_sec" -gt "$now_sec" ]; then
            time_left=$((prayer_sec - now_sec))
            hours=$((time_left / 3600))
            minutes=$(( (time_left % 3600) / 60 ))
            printf "Time left until %s: %02d:%02d" "$prayer_name" "$hours" "$minutes"
            return
        fi
    done <<< "$prayer_times"
    
    # If all prayers passed, show time until next Imsak
    imsak_time=$(grep 'İmsak:' "$cache_file" | awk '{print $2}')
    imsak_sec=$(date -d "$imsak_time" +%s)
    time_left=$((imsak_sec - now_sec + 86400))  # Add 24 hours in seconds
    hours=$((time_left / 3600))
    minutes=$(( (time_left % 3600) / 60 ))
    printf "Time left until İmsak (Tomorrow): %02d:%02d" "$hours" "$minutes"
}

check_cache || fetch_data

cache_date=$(date -d "@$(stat -c %Y "$cache_file")" +"Last updated at: %H:%M, %B %d")
remaining_time=$(get_remaining_time)

case $BLOCK_BUTTON in
    1) notify-send "İstanbul Namaz Vakitleri" "$(printf "%s\n\n%s\n\n%s" "$cache_date" "$(cat "$cache_file")" "$remaining_time")" ;;
    2) fetch_data ;;
    3) notify-send "ℹ️ Prayer Times Module" "Left-click: Show notification\nMiddle-click: Refresh\nRight-click: Info" ;;
    6) st -e nvim "$0" ;;
esac

echo "$icon"
