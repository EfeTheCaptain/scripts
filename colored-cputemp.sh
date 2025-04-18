#!/bin/sh
temperature=$(sensors | awk '/Core 0/ {print int($3)}' | tr -d '+°C')

# Select icon and color based on temperature
if [ "$temperature" -lt 45 ]; then
    icon=""
    color="^c#097bee^"
elif [ "$temperature" -lt 55 ]; then
    icon=""
    color="^c#96ee09^"
elif [ "$temperature" -lt 65 ]; then
    icon=""
    color="^c#eed709^"
else
    icon=""
    color="^c#ee2b09^"
fi

case $BLOCK_BUTTON in
    1)	aplay /home/efe/audio/ss-click.wav
	notify-send "🖥 CPU hogs" "$(ps axch -o cmd,%cpu | awk '{cmd[$1]+=$2} END {for (i in cmd) print i, cmd[i]}' | sort -nrk2 | head)\\n(100% per core)" ;;
    2) aplay /home/efe/audio/ss-click.wav
	st -e htop ;;
    6) aplay /home/efe/audio/ss-click.wav
	st -e nvim "$0" ;;
esac


# Output formatted temperature
echo "${color}${icon}^d^ ${temperature}°C"
