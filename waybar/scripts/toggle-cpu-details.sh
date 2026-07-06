#!/usr/bin/env bash
# toggle-cpu-details.sh — Toggles expanded CPU stats in waybar
STATE_FILE="/tmp/waybar-cpu-expanded"

if [ -f "$STATE_FILE" ]; then
    rm "$STATE_FILE"
else
    touch "$STATE_FILE"
fi

# Signal waybar to refresh the custom module
pkill -RTMIN+8 waybar
