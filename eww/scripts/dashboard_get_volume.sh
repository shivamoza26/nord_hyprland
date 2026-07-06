#!/usr/bin/env bash
set -euo pipefail

if command -v wpctl >/dev/null 2>&1; then
  v="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print $2}')"
  if [[ -n "${v:-}" ]]; then
    awk -v x="$v" 'BEGIN { n=int(x*100+0.5); if (n<0) n=0; if (n>150) n=150; print n }'
    exit 0
  fi
fi

if command -v pactl >/dev/null 2>&1; then
  v="$(pactl get-sink-volume @DEFAULT_SINK@ 2>/dev/null | sed -n 's/.* \([0-9]\{1,3\}\)%.*/\1/p' | head -n1)"
  if [[ -n "${v:-}" ]]; then
    awk -v n="$v" 'BEGIN { if (n<0) n=0; if (n>150) n=150; print int(n) }'
    exit 0
  fi
fi

echo 0
