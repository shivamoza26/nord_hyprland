#!/usr/bin/env bash
set -euo pipefail

WINDOW_NAME="control-hub"

if ! eww ping >/dev/null 2>&1; then
  eww daemon
  sleep 0.2
fi

if command -v hyprctl >/dev/null 2>&1; then
  hyprctl keyword layerrule "blur, eww-dashboard" >/dev/null 2>&1 || true
  hyprctl keyword layerrule "ignorealpha 0.2, eww-dashboard" >/dev/null 2>&1 || true
fi

if eww active-windows | grep -q "${WINDOW_NAME}"; then
  eww close "${WINDOW_NAME}"
else
  eww open "${WINDOW_NAME}"
fi
