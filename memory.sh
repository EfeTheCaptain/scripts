#!/bin/sh

case $BLOCK_BUTTON in
	1) aplay /home/efe/audio/ss-click.wav
		notify-send " Memory hogs" "$(ps axch -o cmd,%mem | awk '{cmd[$1]+=$2} END {for (i in cmd) print i, cmd[i]}' | sort -nrk2 | head)" ;;
	2) aplay /home/efe/audio/ss-click.wav
		setsid -f st -e htop ;;
	3) aplay /home/efe/audio/ss-click.wav
		notify-send " Memory module" "\- Shows Memory Used/Total.
- Click to show memory hogs.
- Middle click to open htop." ;;
	6) aplay /home/efe/audio/ss-click.wav
		st -e nvim "$0" ;;
esac

free --mebi | sed -n '2{p;q}' | awk '{printf ("^c#3a7984^ ^d^ %dMB/%.0fGB\n", $3, ($2 / 1024))}'
