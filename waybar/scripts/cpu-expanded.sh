#!/usr/bin/env bash
# cpu-expanded.sh — Returns JSON for the custom/cpu-expanded module
# Click toggles between compact (just CPU%) and expanded (CPU + Temp + RAM + Disk)

STATE_FILE="/tmp/waybar-cpu-expanded"

# ── Gather stats ────────────────────────────────────────────
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}')

# CPU temp via sensors (requires lm-sensors)
CPU_TEMP=""
if command -v sensors &>/dev/null; then
    CPU_TEMP=$(sensors 2>/dev/null \
        | grep -E 'Core 0|Tdie|Package|CPU Temp' \
        | head -1 \
        | grep -oP '\+[0-9.]+°C' \
        | head -1 \
        | tr -d '+')
fi

# RAM usage
RAM_TOTAL=$(free -m | awk '/^Mem/{print $2}')
RAM_USED=$(free -m  | awk '/^Mem/{print $3}')
RAM_PCT=$(awk "BEGIN {printf \"%d\", ($RAM_USED/$RAM_TOTAL)*100}")

# Swap usage
SWAP_TOTAL=$(free -m | awk '/^Swap/{print $2}')
SWAP_USED=$(free -m  | awk '/^Swap/{print $3}')
if [ "$SWAP_TOTAL" -gt 0 ]; then
    SWAP_PCT=$(awk "BEGIN {printf \"%d\", ($SWAP_USED/$SWAP_TOTAL)*100}")
    SWAP_STR="Swap: ${SWAP_USED}M / ${SWAP_TOTAL}M (${SWAP_PCT}%)"
else
    SWAP_STR="Swap: N/A"
fi

# Disk usage
DISK_USED=$(df -h / | awk 'NR==2{print $3}')
DISK_TOTAL=$(df -h / | awk 'NR==2{print $2}')
DISK_PCT=$(df / | awk 'NR==2{print $5}' | tr -d '%')

# ── CPU colour class ─────────────────────────────────────────
if   [ "$CPU_USAGE" -ge 90 ]; then CLASS="critical"
elif [ "$CPU_USAGE" -ge 60 ]; then CLASS="warning"
else CLASS="normal"
fi

# ── Decide display mode ──────────────────────────────────────
if [ -f "$STATE_FILE" ]; then
    # EXPANDED mode
    TEMP_PART=""
    [ -n "$CPU_TEMP" ] && TEMP_PART=" 󰔏 ${CPU_TEMP}"

    TEXT="󰻠 ${CPU_USAGE}%${TEMP_PART}  󰘚 ${RAM_PCT}%  󰋊 ${DISK_PCT}%"
    TOOLTIP="CPU: ${CPU_USAGE}%\n${CPU_TEMP:+Temp: $CPU_TEMP\n}RAM: ${RAM_USED}M / ${RAM_TOTAL}M (${RAM_PCT}%)\n${SWAP_STR}\nDisk: ${DISK_USED} / ${DISK_TOTAL} (${DISK_PCT}%)\nClick to collapse"
else
    # COMPACT mode — just show CPU
    TEXT="󰻠 ${CPU_USAGE}%"
    TOOLTIP="CPU: ${CPU_USAGE}%\n${CPU_TEMP:+Temp: $CPU_TEMP\n}RAM: ${RAM_USED}M / ${RAM_TOTAL}M (${RAM_PCT}%)\n${SWAP_STR}\nDisk: ${DISK_USED} / ${DISK_TOTAL} (${DISK_PCT}%)\nClick to expand"
fi

# ── Output JSON for waybar ───────────────────────────────────
printf '{"text": "%s", "tooltip": "%s", "class": "%s"}\n' \
    "$TEXT" \
    "$(printf '%s' "$TOOLTIP" | sed 's/"/\\"/g')" \
    "$CLASS"
