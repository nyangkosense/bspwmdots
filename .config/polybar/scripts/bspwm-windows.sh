#!/bin/bash

# Get all window IDs and their titles from the current desktop
windows=$(bspc query -N -n .window -d focused)

# If there are no windows, print "Desktop" and exit
if [ -z "$windows" ]; then
    echo "Desktop"
    exit 0
fi

result=""
separator=" "

# Loop through each window ID
for wid in $windows; do
    # Get window title
    title=$(xprop -id $wid WM_NAME 2>/dev/null | sed -n 's/^WM_NAME(STRING) = "\(.*\)"/\1/p')
    
    # Check if window is focused
    focused=$(bspc query -N -n focused)
    
    # If title is empty or too long, use a default name
    if [ -z "$title" ]; then
        title="Window"
    else
        # Truncate title if it's too long
        if [ ${#title} -gt 15 ]; then
            title="${title:0:15}..."
        fi
    fi
    
    # Add window to result
    if [ "$wid" = "$focused" ]; then
        result="$result$separator$title"
    else
        result="$result$separator$title"
    fi
done

echo "${result:${#separator}}" # Remove first separator
