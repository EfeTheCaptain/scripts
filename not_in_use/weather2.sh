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

# Format the notification message
message="Location:$location\nCondition:$icon$condition\nTemperature:$temperature\nFeels Like:$feels_like\nPrecipitation:$precipitation\nMoon Phase:$moonphase"

# Output for dwmblocks (Condition + Feels Like only)
dwmblocks_output="$clean_icon$feels_like°C"

# Print dwmblocks output
echo "$dwmblocks_output"

# Handle clicks
case $BLOCK_BUTTON in
	1) notify-send "Weather" "$message" ;;  # Left-click → Notification
	2) weather_data ;; #fetch data manually
	6) st -e nvim "$0" ;;  # Shift-click → Edit script
esac
