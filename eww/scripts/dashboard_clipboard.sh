#!/usr/bin/env bash
set -euo pipefail

ROFI_THEME="$HOME/.config/waybar/scripts/rofi-nord.rasi"

if ! command -v cliphist >/dev/null 2>&1; then
    notify-send "Clipboard" "cliphist is not installed"
    exit 1
fi

# Toggle behavior: if a rofi menu is already open, close it.
rofi_pid="$(pgrep -u "$UID" -x rofi | head -n1 || true)"
if [[ -n "${rofi_pid}" ]]; then
    kill "${rofi_pid}"
    exit 0
fi

selection="$(
    cliphist list | rofi -dmenu -p "Clipboard" -theme "$ROFI_THEME" -i -no-custom
)"

if [[ -n "${selection}" ]]; then
    printf '%s' "${selection}" | cliphist decode | wl-copy
    notify-send "Clipboard" "Copied selection"
fi
