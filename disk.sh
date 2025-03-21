#!/usr/bin/env bash

# Array of disks and matching icons
DISKS=("/" "/home")
ICONS=(" " " ")

# Define a file to save current disk and format, and initialize if not found
DISKS_FILE="/tmp/dwmblocks_disk_info"
[ -f "$DISKS_FILE" ] || echo "0 0" > "$DISKS_FILE"

# Read INDEX number and FORMAT number from the file
read INDEX FORMAT < "$DISKS_FILE"

# Set the current disk and icon per INDEX #
CURRENT_DISK="${DISKS[$INDEX]}"
ICON="${ICONS[$INDEX]}"

# Pull usage % and space remaining of that disk
# Could add more display formats here
PERCENT=$(df -h "$CURRENT_DISK" | awk 'NR==2 {print $5}')
SPACE=$(df -h "$CURRENT_DISK" | awk 'NR==2 {print $4}')

# If format is 0, display usage %, otherwise, space remaining
# Could instead use a case statement if more formats are added
[ "$FORMAT" -eq 0 ] && INFO="$PERCENT" || INFO="$SPACE"

# If left-clicked, go to next disk
# If right-clicked, go to previous disk
# If middle-clicked, change format
# Modulo used to wrap around when it reaches end of disks array or format #s
case $BLOCK_BUTTON in
		1) echo "$(( ($INDEX + 1) % ${#DISKS[@]} )) $FORMAT" > "$DISKS_FILE" ;;
		3) echo "$(( ($INDEX - 1) % ${#DISKS[@]} )) $FORMAT" > "$DISKS_FILE" ;;
		2) echo "$INDEX $(( ($FORMAT + 1) % 2 ))" > "$DISKS_FILE" ;;
		6) st -e nvim "$0" ;;
esac

# Send to bar
echo "$ICON$INFO"

# Can set this script to refresh on a timer in dwmblocks blocks.h
# If you want this to cycle through visible disks on that timer, remove the (INDEX + 1) out of the case BLOCK_BUTTON and add it to the end of the script instead
