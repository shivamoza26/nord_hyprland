#!/usr/bin/env bash
set -euo pipefail

if ! command -v kitty >/dev/null 2>&1; then
  notify-send "Update" "kitty is required to run updates interactively"
  exit 1
fi

update_cmd=""

if command -v yay >/dev/null 2>&1; then
  update_cmd="yay -Syu"
elif command -v paru >/dev/null 2>&1; then
  update_cmd="paru -Syu"
elif command -v pacman >/dev/null 2>&1; then
  update_cmd="sudo pacman -Syu"
elif command -v apt >/dev/null 2>&1; then
  update_cmd="sudo apt update && sudo apt upgrade"
elif command -v dnf >/dev/null 2>&1; then
  update_cmd="sudo dnf upgrade --refresh"
else
  notify-send "Update" "No supported package manager found"
  exit 1
fi

kitty --title "System Update" bash -lc "${update_cmd}; rc=\$?; echo; if [ \$rc -eq 0 ]; then echo 'Update complete.'; else echo 'Update failed.'; fi; echo; read -n1 -rsp 'Press any key to close...'"
