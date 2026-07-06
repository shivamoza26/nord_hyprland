ROFI_THEME="$HOME/.config/rofi/clipboard/clipboard.rasi"

cliphist list | rofi -dmenu -display-columns 2 -p "Clipboard" -l 10 -theme "$ROFI_THEME" -no-custom | cliphist decode | wl-copy
