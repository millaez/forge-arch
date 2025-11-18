#!/bin/bash
set -e

# MythOS Gaming Pillar — MangoHud Setup

echo "📊 Installing MangoHud and GameMode..."

# Install MangoHud + GameMode
sudo pacman -S --needed --noconfirm \
    mangohud \
    lib32-mangohud \
    gamemode \
    lib32-gamemode

# Create MangoHud config
mkdir -p ~/.config/MangoHud

cat > ~/.config/MangoHud/MangoHud.conf << 'EOF'
# MythOS MangoHud Configuration

# Basic layout
position=top-left
no_display=false

# Performance metrics
fps
frametime=0
frame_timing=1
cpu_temp
gpu_temp
cpu_stats
gpu_stats
ram
vram

# Visual settings
font_size=24
background_alpha=0.5
text_outline=true
text_outline_thickness=1

# Logging
output_folder=/tmp
log_duration=30
EOF

# Set up GameMode configuration
sudo tee /etc/gamemode.ini > /dev/null << 'EOF'
[general]
renice=10

[gpu]
apply_gpu_optimisations=accept-responsibility
gpu_device=0

[cpu]
park_cores=no
pin_cores=no
EOF

# Enable GameMode daemon
sudo systemctl enable --now gamemoded

echo "✅ MangoHud and GameMode configured!"
echo "💡 Use 'mangohud %command%' in Steam launch options"
echo "💡 Use 'gamemoderun <game>' to run with GameMode"
