#!/bin/sh

# Weather API URL and location
LOCATION="Istanbul"
WEATHER_URL="wttr.in/$LOCATION?format=%l\n+%c\n%C\n+%t\n+%f\n+%p\n+%m\n"

# Fetch the weather data
weather_data=$(curl -s "$WEATHER_URL")

# Extract lines using `sed` (or use `awk 'NR==n'`)
location=$(echo "$weather_data" | sed -n '1p')
icon=$(echo "$weather_data" | sed -n '2p')
condition=$(echo "$weather_data" | sed -n '3p')
temperature=$(echo "$weather_data" | sed -n '4p')
feels_like=$(echo "$weather_data" | sed -n '5p' | tr -d '+°C')
precipitation=$(echo "$weather_data" | sed -n '6p')
moonphase=$(echo "$weather_data" | sed -n '7p')

#cleanup the icon empty spaces
clean_icon=$(echo "$icon" | sed 's/^ *//;s/ *$//')

# Determine color for feels_like
if [ "$feels_like" -lt 0 ]; then
    color="^c#1d1ad9^"
elif [ "$feels_like" -lt 10 ]; then
    color="^c#1a96d9^"
elif [ "$feels_like" -lt 20 ]; then
    color="^c#1ad9af^"
elif [ "$feels_like" -lt 30 ]; then
    color="^c#d9d91a^"
else
    color="^c#e3620b^"
fi

# Format colored output for dwmblocks
dwmblocks_output="$clean_icon ${color}${feels_like}°C^d^"

# Print dwmblocks output
echo "$dwmblocks_output"

# Format notification message
message="Location: $location\nCondition: $icon$condition\nTemperature: $temperature\nFeels Like: $feels_like°C\nPrecipitation: $precipitation\nMoon Phase: $moonphase"

# Handle clicks
case $BLOCK_BUTTON in
    1)
        timestamp=$(date +"%Y-%m-%d %H:%M:%S")
        notify-send "Weather" "$message\nLast Checked: $timestamp" ;;  # Left-click → Notification with timestamp
    6) st -e nvim "$0" ;;  # Middle-click → Edit script
esac
