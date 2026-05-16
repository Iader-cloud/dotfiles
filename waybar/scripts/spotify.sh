#!/bin/bash
# ════════════════════════════════════════════════════════════
#  spotify.sh — Módulo centro: estado del player
#  Output JSON: { text, class, tooltip }
#  Click: play/pause | Scroll: next/prev
# ════════════════════════════════════════════════════════════

PLAYER="spotify"
STATUS=$(playerctl --player="$PLAYER" status 2>/dev/null)

if [ -z "$STATUS" ] || [ "$STATUS" = "No players found" ]; then
    echo '{"text":"  sin media","class":"stopped","tooltip":""}'
    exit 0
fi

TITLE=$(playerctl --player="$PLAYER" metadata title  2>/dev/null)
ARTIST=$(playerctl --player="$PLAYER" metadata artist 2>/dev/null)

# Truncar título largo
if [ ${#TITLE} -gt 22 ]; then
    SHORT="${TITLE:0:22}…"
else
    SHORT="$TITLE"
fi

if [ "$STATUS" = "Playing" ]; then
    ICON="⏸"
    CLASS="playing"
elif [ "$STATUS" = "Paused" ]; then
    ICON="⏵"
    CLASS="paused"
else
    echo '{"text":"  sin media","class":"stopped","tooltip":""}'
    exit 0
fi

TOOLTIP="${ARTIST} — ${TITLE}"

# Escapar caracteres JSON
TOOLTIP="${TOOLTIP//\"/\\\"}"
SHORT="${SHORT//\"/\\\"}"

echo "{\"text\":\"${ICON}  ${SHORT}\",\"class\":\"${CLASS}\",\"tooltip\":\"${TOOLTIP}\"}"
