#!/bin/bash

# Print label for waybar music module.
if [ "${1-}" = "--label" ]; then
    TITLE=$(playerctl metadata --format='{{ title }}' 2>/dev/null)
    if [ -n "$TITLE" ]; then
        echo "$TITLE"
    else
        echo "Music"
    fi
    exit 0
fi

# 1. Try to see if the window is open
IF_OPEN=$(eww active-windows | grep "media_player")

if [ -n "$IF_OPEN" ]; then
    # If it's open, try to close it gracefully
    eww close media_player
    # Give it a millisecond to breathe, then kill any lingering eww processes 
    # just to be safe so the daemon stays clean
    sleep 0.1
else
    # If it's NOT open (or eww is bugged), kill everything and start fresh
    pkill eww
    eww daemon
    sleep 0.2 # Wait for daemon to wake up
    eww open media_player
fi
