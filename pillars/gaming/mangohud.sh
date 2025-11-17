#!/bin/bash
# Install MangoHud for FPS overlay

set -e

echo "📊 Installing MangoHud..."

pacman -S --noconfirm --needed mangohud lib32-mangohud

# Create default config
mkdir -p "$HOME/.config/MangoHud"
cat > "$HOME/.config/MangoHud/MangoHud.conf" << 'EOF'
fps
frametime=0
gpu_stats
cpu_stats
position=top-left
toggle_hud=Shift_R+F12
EOF

echo "✅ MangoHud installed"
