#!/bin/bash

STATE_FILE="/tmp/waybar_active_display"

# Default to logical display 1 if state file doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "1" > "$STATE_FILE"
fi

# ACTIVE_DISPLAY is the LOGICAL index (what the user sees: M1, M2)
ACTIVE_DISPLAY=$(cat "$STATE_FILE")

# Mapping Logical -> Physical (ddcutil index)
# Logical 1 (M1) -> Physical 2 (DP-3 / LG)
# Logical 2 (M2) -> Physical 1 (HDMI / ARZOPA)
get_physical_index() {
    if [ "$1" -eq 1 ]; then
        echo "2"
    else
        echo "1"
    fi
}

PHYSICAL_INDEX=$(get_physical_index "$ACTIVE_DISPLAY")

get_brightness() {
    local physical=$1
    ddcutil getvcp 10 --display "$physical" 2>/dev/null | grep -oP 'current value =\s*\K[0-9]+' | head -1
}

get_model() {
    local physical=$1
    ddcutil detect 2>/dev/null | grep -A 10 "Display $physical" | grep -oP 'Model:\s*\K.*' | head -1
}

case "$1" in
    focus_up|focus_down)
        # 1. Ask Hyprland for the currently focused monitor
        MONITOR_NAME=$(hyprctl activeworkspace -j | grep -oP '"monitor": "\K[^"]+')
        
        # 2. Map the Hyprland monitor to our LOGICAL index
        # User wants DP-3 to be M1
        LOGICAL_INDEX=2
        if [[ "$MONITOR_NAME" == *"DP-3"* ]]; then
            LOGICAL_INDEX=1
        fi
        
        # 3. Sync the Waybar state
        echo "$LOGICAL_INDEX" > "$STATE_FILE"
        ACTIVE_DISPLAY=$LOGICAL_INDEX
        PHYSICAL_INDEX=$(get_physical_index "$ACTIVE_DISPLAY")
        
        # 4. Apply the brightness change
        if [ "$1" = "focus_up" ]; then
            ddcutil setvcp 10 + 5 --display "$PHYSICAL_INDEX" > /dev/null 2>&1
        else
            ddcutil setvcp 10 - 5 --display "$PHYSICAL_INDEX" > /dev/null 2>&1
        fi
        ;;
    toggle)
        if [ "$ACTIVE_DISPLAY" -eq 1 ]; then
            echo "2" > "$STATE_FILE"
        else
            echo "1" > "$STATE_FILE"
        fi
        ;;
    up)
        ddcutil setvcp 10 + 5 --display "$PHYSICAL_INDEX" > /dev/null 2>&1
        ;;
    down)
        ddcutil setvcp 10 - 5 --display "$PHYSICAL_INDEX" > /dev/null 2>&1
        ;;
    get|*)
        BRIGHTNESS=$(get_brightness "$PHYSICAL_INDEX")
        MODEL=$(get_model "$PHYSICAL_INDEX")

        if [ -z "$MODEL" ]; then
            if [ "$PHYSICAL_INDEX" -eq 2 ]; then
                MODEL="LG ULTRAGEAR"
            else
                MODEL="ARZOPA"
            fi
        fi

        if [ -n "$BRIGHTNESS" ]; then
            TEXT="M$ACTIVE_DISPLAY:$BRIGHTNESS%"
            TOOLTIP="Monitor: $MODEL\nBrightness: $BRIGHTNESS%"
            echo "{\"text\": \"$TEXT\", \"tooltip\": \"$TOOLTIP\"}"
        else
            echo "{\"text\": \"M$ACTIVE_DISPLAY:--\", \"tooltip\": \"No DDC display found for $MODEL (Physical $PHYSICAL_INDEX)\"}"
        fi
        ;;
esac
