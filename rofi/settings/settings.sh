#!/usr/bin/env bash

ROFI_THEME="$HOME/.config/rofi/settings/settings.rasi"

# Check if choice was passed as an argument
if [[ $# -gt 0 ]]; then
    choice="$1"
else
    choice="$(
        printf '%s\n' \
            "Hyprland" \
            "Waybar" \
            "Rofi" \
            "Swaync" \
            "Yazi" \
            "Fastfetch" \
            "Kitty" \
            "Neovim" \
            "Eww" |
            rofi -dmenu -p "⚙" -theme "$ROFI_THEME" \
                -i -no-custom
    )" || exit 0
fi

case "${choice}" in
"Hyprland")
    target="$HOME/.config/hypr/"
    ;;
"Waybar")
    target="$HOME/.config/waybar"
    ;;
"Rofi")
    target="$HOME/.config/rofi"
    ;;
"Swaync")
    target="$HOME/.config/swaync"
    ;;
"Yazi")
    target="$HOME/.config/yazi"
    ;;
"Fastfetch")
    target="$HOME/.config/fastfetch/"
    ;;
"Kitty")
    target="$HOME/.config/kitty"
    ;;
"Neovim")
    target="$HOME/.config/nvim"
    ;;
"Eww")
    target="$HOME/.config/eww"
    ;;
*)
    exit 0
    ;;
esac

# Silent exit if target path does not exist
if [[ ! -e "${target}" ]]; then
    exit 1
fi

#Open in Neovim
kitty --directory "$target" nvim .
