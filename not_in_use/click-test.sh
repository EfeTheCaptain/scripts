#!/bin/bash

# Check for Signal 1 (left-click)
if [[ "$BLOCK_BUTTON" == "1" ]]; then
    # Action for left-click
    echo "Left Click detected"
    ${TERMINAL:-st} -e htop &
    exit 0  # Exit after handling the signal
fi

# Check for Signal 6 (Shift + left-click)
if [[ "$BLOCK_BUTTON" == "6" ]]; then
    # Action for Shift + left-click
    echo "Shift + Left Click detected"
    ${TERMINAL:-st} -e nvim &
    exit 0  # Exit after handling the signal
fi

# Default block output (this will be shown if no button is clicked)
echo "My Block"
