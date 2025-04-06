#!/bin/bash
case $BLOCK_BUTTON in
    6) st -e nvim "$0" ;;
esac

# Get the hour and minute only once
read -r hour minute < <(date +"%H %M")

  echo "$hour:$minute"
