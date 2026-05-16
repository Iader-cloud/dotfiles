#!/bin/bash
# ════════════════════════════════════════════════════════════
#  cava.sh [left|right]
#  Lee el frame actual del daemon y muestra la mitad pedida
#  Los bloques simulan waveform: ▁▂▃▄▅▆▇█
# ════════════════════════════════════════════════════════════

SIDE="${1:-left}"
FRAME_FILE="/tmp/cava_frame"
BLOCKS="▁▂▃▄▅▆▇█"
EMPTY="▁▁▁▁▁▁▁▁"

# Esperar al daemon (máx 15s)
timeout=30
while [ ! -f "$FRAME_FILE" ] && [ $timeout -gt 0 ]; do
    sleep 0.5
    (( timeout-- ))
done

while true; do
    if [ -f "$FRAME_FILE" ]; then
        LINE=$(cat "$FRAME_FILE" 2>/dev/null)
        OUTPUT=""

        IFS=';' read -ra VALS <<< "$LINE"
        TOTAL=${#VALS[@]}

        if [ "$TOTAL" -gt 1 ]; then
            HALF=$(( TOTAL / 2 ))

            if [ "$SIDE" = "left" ]; then
                START=0
                END=$HALF
            else
                START=$HALF
                END=$TOTAL
            fi

            for (( i=START; i<END; i++ )); do
                v="${VALS[$i]//[^0-9]/}"
                [ -z "$v" ] && v=0
                (( v > 7 )) && v=7
                OUTPUT+="${BLOCKS:$v:1}"
            done

            echo "${OUTPUT:-$EMPTY}"
        else
            echo "$EMPTY"
        fi
    else
        echo "$EMPTY"
    fi

    sleep 0.04   # ~25fps — ligero para R2/R3
done
