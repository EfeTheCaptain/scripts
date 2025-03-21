#!/bin/sh

case $BLOCK_BUTTON in
	1) notify-send "🖥 CPU hogs" "$(ps axch -o cmd,%cpu | awk '{cmd[$1]+=$2} END {for (i in cmd) print i, cmd[i]}' | sort -nrk2  | head)\\n(100% per core)" ;;
	2) st -e htop ;;
	6) st -e nvim "$0" ;;
	3) notify-send "🖥 CPU module"
esac

temperature=$(sensors | awk '/Core 0/ {print int($3)"°C"}')
echo "^c#666666^${temperature}^d^"
