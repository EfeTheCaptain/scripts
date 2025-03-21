#!/bin/sh

case $BLOCK_BUTTON in
    1) notify-send "This Month" "$(cal | sed "s/\<$(date +'%e'|tr -d ' ')\>/<b><span color='red'>&<\/span><\/b>/")" && notify-send "To-Do List" "$(calcurse -t)" ;;
    3) st -e calcurse ;;
    2) notify-send "📅 Date module" "\- Left click to show your to-do list via \`calcurse -t\` and the month via \`cal\`
- Middle click opens calcurse if installed" ;;
    6) st -e nvim "$0" ;;
esac

date "+%b %d"
