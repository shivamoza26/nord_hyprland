#!/usr/bin/env bash
set -euo pipefail

WALL_DIR="${WALL_DIR:-$HOME/Pictures/wallpaper}"
ROFI_THEME="${ROFI_THEME:-$HOME/.config/rofi/Wallpaper/wallpaper.rasi}"
AWWW_TRANSITION_TYPE="${AWWW_TRANSITION_TYPE:-random}"
AWWW_TRANSITION_DURATION="${AWWW_TRANSITION_DURATION:-1.0}"
AWWW_TRANSITION_FPS="${AWWW_TRANSITION_FPS:-60}"

mapfile -d '' wallpapers < <(
  find "$WALL_DIR" -maxdepth 1 -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.bmp' \) \
    -print0 | sort -z
)

if (( ${#wallpapers[@]} == 0 )); then
  echo "Error: no wallpapers found in $WALL_DIR"
  exit 1
fi

selection_index="$(
  {
    printf '[Random]\0icon\x1f%s\n' "${wallpapers[0]}"
    for wp in "${wallpapers[@]}"; do
      printf '%s\0icon\x1f%s\n' "$(basename "$wp")" "$wp"
    done
  } | rofi -dmenu -i -p "Wallpaper" -theme "$ROFI_THEME" -show-icons -format i
)"

[[ -z "${selection_index:-}" ]] && exit 0

if [[ "$selection_index" == "0" ]]; then
  selected_wallpaper="$(printf '%s\n' "${wallpapers[@]}" | shuf -n 1)"
else
  if [[ ! "$selection_index" =~ ^[0-9]+$ ]]; then
    echo "Error: invalid selection index."
    exit 1
  fi

  wallpaper_idx=$((selection_index - 1))
  if (( wallpaper_idx < 0 || wallpaper_idx >= ${#wallpapers[@]} )); then
    echo "Error: selected wallpaper index out of range."
    exit 1
  fi

  selected_wallpaper="${wallpapers[$wallpaper_idx]}"
fi

if [[ -z "$selected_wallpaper" ]]; then
  echo "Error: selected wallpaper not found."
  exit 1
fi

awww img "$selected_wallpaper" \
  --transition-type "$AWWW_TRANSITION_TYPE" \
  --transition-duration "$AWWW_TRANSITION_DURATION" \
  --transition-fps "$AWWW_TRANSITION_FPS"

