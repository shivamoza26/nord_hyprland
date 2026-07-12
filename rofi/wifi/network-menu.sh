#!/usr/bin/env bash
ROFI_THEME="$HOME/.config/rofi/wifi/wifi.rasi"

WIFI_IFACE="$(nmcli -t -f DEVICE,TYPE dev status | awk -F: '$2=="wifi"{print $1; exit}')"
if [[ -n "${WIFI_IFACE}" ]]; then
    SCAN_OUTPUT="$(timeout 2s nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list ifname "${WIFI_IFACE}" --rescan no 2>/dev/null || true)"
else
    SCAN_OUTPUT="$(timeout 2s nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list --rescan no 2>/dev/null || true)"
fi

# Get current connection status from the same scan output.
CURRENT="$(printf '%s\n' "${SCAN_OUTPUT}" | awk -F: '$1=="*"{print $2; exit}')"
HEADER="${CURRENT:+Connected: $CURRENT}"

# List available networks
NETWORKS=$(printf '%s\n' "${SCAN_OUTPUT}" |
    sort -t: -k3 -rn |
    awk -F: '!seen[$2]++ && $2!=""' |
    while IFS=: read -r _in_use ssid signal security; do
        # Signal icon
        if [ "${signal:-0}" -ge 75 ]; then
            icon="󰤨"
        elif [ "${signal:-0}" -ge 50 ]; then
            icon="󰤥"
        elif [ "${signal:-0}" -ge 25 ]; then
            icon="󰤢"
        else
            icon="󰤟"
        fi
        # Lock icon if secured
        [ -n "$security" ] && lock=" 󰌾" || lock=""
        echo "$icon  $ssid ($signal%)$lock"
    done)

# Extra options
EXTRA="󰖪  Disconnect\n󰤭  Enable/Disable WiFi\n󰙿  Open nm-connection-editor"

CHOICE=$(printf '%s\n%s' "$NETWORKS" "$(printf "$EXTRA")" | rofi \
    -dmenu \
    -p "${HEADER:-WiFi Networks}" \
    -theme "$ROFI_THEME" \
    -no-custom \
    -i)

# Extract SSID from choice (between first spaces and the parenthesis)
SSID=$(echo "$CHOICE" | sed 's/^[^ ]* \+ //;s/ (.*//')

case "$CHOICE" in
*"Disconnect"*)
    nmcli device disconnect wlan0 2>/dev/null ||
        nmcli device disconnect $(nmcli -t -f device,type dev | grep wifi | cut -d: -f1 | head -1)
    notify-send "Network" "Disconnected from WiFi"
    ;;
*"Enable/Disable WiFi"*)
    STATE=$(nmcli radio wifi)
    if [ "$STATE" = "enabled" ]; then
        nmcli radio wifi off
        notify-send "Network" "WiFi disabled"
    else
        nmcli radio wifi on
        notify-send "Network" "WiFi enabled"
    fi
    ;;
*"nm-connection-editor"*)
    nm-connection-editor &
    ;;
"")
    # User cancelled
    ;;
*)
    # Try to connect to selected SSID
    # Check if we already have credentials saved
    KNOWN=$(nmcli -t -f name con show | grep -F "$SSID")
    if [ -n "$KNOWN" ]; then
        nmcli con up "$SSID" && notify-send "Network" "Connected to $SSID" ||
            notify-send -u critical "Network" "Failed to connect to $SSID"
    else
        # Prompt for password
        PASS=$(rofi -dmenu -p "Password for $SSID" -theme "$ROFI_THEME" \
            -password </dev/null)
        if [ -n "$PASS" ]; then
            nmcli dev wifi connect "$SSID" password "$PASS" &&
                notify-send "Network" "Connected to $SSID" ||
                notify-send -u critical "Network" "Failed to connect to $SSID"
        fi
    fi
    ;;
esac
