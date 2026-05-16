#!/bin/bash
# ════════════════════════════════════════════════════════════
#  spotify_track.sh — Isla dinámica (4ta isla)
#  Aparece SOLO cuando Spotify está Playing o Paused
#  .stopped → CSS oculta el módulo con opacity:0
# ════════════════════════════════════════════════════════════

STATUS=$(playerctl --player=spotify status 2>/dev/null)

case "$STATUS" in
    Playing)
        TITLE=$(playerctl --player=spotify metadata title  2>/dev/null)
        ARTIST=$(playerctl --player=spotify metadata artist 2>/dev/null)

        if [ ${#TITLE} -gt 24 ]; then
            SHORT="${TITLE:0:24}…"
        else
            SHORT="$TITLE"
        fi

        SHORT="${SHORT//\"/\\\"}"
        TOOLTIP="${ARTIST//\"/\\\"} — ${TITLE//\"/\\\"}"

        echo "{\"text\":\"♪  ${SHORT}\",\"class\":\"playing\",\"tooltip\":\"${TOOLTIP}\"}"
        ;;

    Paused)
        TITLE=$(playerctl --player=spotify metadata title  2>/dev/null)
        ARTIST=$(playerctl --player=spotify metadata artist 2>/dev/null)

        if [ ${#TITLE} -gt 24 ]; then
            SHORT="${TITLE:0:24}…"
        else
            SHORT="$TITLE"
        fi

        SHORT="${SHORT//\"/\\\"}"
        TOOLTIP="${ARTIST//\"/\\\"} — ${TITLE//\"/\\\"}"

        echo "{\"text\":\"⏸  ${SHORT}\",\"class\":\"paused\",\"tooltip\":\"${TOOLTIP}\"}"
        ;;

    *)
        # Stopped / no spotify → CSS la oculta con opacity:0
        echo '{"text":"","class":"stopped","tooltip":""}'
        ;;
esac
