#!/bin/bash
# ════════════════════════════════════════════════════════════
#  autohide.sh — Escucha eventos Hyprland
#  Fullscreen activo   → SIGUSR1 → waybar se oculta
#  Fullscreen inactivo → SIGUSR1 → waybar se muestra
#  (SIGUSR1 es toggle en waybar)
# ════════════════════════════════════════════════════════════

SOCKET="/tmp/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
IS_HIDDEN=0

# Esperar a que el socket exista
while [ ! -S "$SOCKET" ]; do
    sleep 0.5
done

socat - "UNIX-CONNECT:${SOCKET}" 2>/dev/null | while IFS= read -r event; do
    # Fullscreen activado
    if echo "$event" | grep -q "fullscreen>>1"; then
        if [ "$IS_HIDDEN" -eq 0 ]; then
            pkill -SIGUSR1 waybar
            IS_HIDDEN=1
        fi
    # Fullscreen desactivado
    elif echo "$event" | grep -q "fullscreen>>0"; then
        if [ "$IS_HIDDEN" -eq 1 ]; then
            pkill -SIGUSR1 waybar
            IS_HIDDEN=0
        fi
    fi
done
