#!/bin/bash

# Get the hour and minute only once
read -r hour minute < <(date +"%H %M")

# Blink the colon (alternates every second)
if [ $(( $(date +%s) % 2 )) -eq 0 ]; then
  echo "$hour:$minute"
else
  echo "$hour $minute"
fi
