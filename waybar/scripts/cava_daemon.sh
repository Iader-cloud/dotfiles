#!/bin/bash
# ════════════════════════════════════════════════════════════
#  cava_daemon.sh — Corre UNA vez (exec-once en Hyprland)
#  Lee audio → escribe frame actual en /tmp/cava_frame
#  Ambos módulos (cava-left / cava-right) leen ese archivo
# ════════════════════════════════════════════════════════════

CONFIG="/tmp/cava_daemon.ini"
FRAME="/tmp/cava_frame"

# Matar instancia previa si existe
pkill -f "cava -p $CONFIG" 2>/dev/null
sleep 0.3

# Configuración de cava
cat > "$CONFIG" << 'EOF'
[general]
bars = 16
framerate = 25
sensitivity = 80
overshoot = 20

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Escribir cada frame en el archivo compartido
# (usa printf sin newline para que la lectura sea atómica)
cava -p "$CONFIG" 2>/dev/null | while IFS= read -r line; do
    printf '%s' "$line" > "$FRAME"
done
