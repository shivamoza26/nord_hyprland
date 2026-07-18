#!/usr/bin/env bash

ROFI_THEME="$HOME/.config/rofi/projects/projects.rasi"
PROJECTS_DIR="$HOME/Projects"

project=$(
    find "$PROJECTS_DIR" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' |
        sort |
        rofi -dmenu -p "" -theme "$ROFI_THEME"

)

# Exit if nothing was selected
[ -z "$project" ] && exit 0

# Change into the project directory
cd "$PROJECTS_DIR/$project" || exit 1

# Open Neovim from that directory
kitty -e nvim .
