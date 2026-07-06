#!/usr/bin/env bash
set -euo pipefail

vol="${1:-0}"

if [[ ! "$vol" =~ ^[0-9]+$ ]]; then
  exit 1
fi

if (( vol < 0 )); then vol=0; fi
if (( vol > 150 )); then vol=150; fi

if command -v wpctl >/dev/null 2>&1; then
  wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ "${vol}%"
  exit 0
fi

if command -v pactl >/dev/null 2>&1; then
  pactl set-sink-volume @DEFAULT_SINK@ "${vol}%"
  exit 0
fi

exit 1
