#!/bin/bash
set -e

# MythOS Gaming Pillar — Steam Setup

echo "🎮 Installing Steam and dependencies..."

# Install Steam
sudo pacman -S --needed --noconfirm \
    steam \
    lib32-nvidia-utils \
    lib32-vulkan-icd-loader

# Install additional Proton dependencies
sudo pacman -S --needed --noconfirm \
    wine \
    wine-mono \
    wine-gecko \
    winetricks

# Create Steam library directories
mkdir -p ~/Games/SteamLibrary

# Enable Steam Play for all titles (Proton)
STEAM_CONFIG="$HOME/.local/share/Steam/config"
mkdir -p "$STEAM_CONFIG"

cat > "$STEAM_CONFIG/config.vdf" << 'EOF'
"InstallConfigStore"
{
    "Software"
    {
        "Valve"
        {
            "Steam"
            {
                "CompatToolMapping"
                {
                    "0"
                    {
                        "name" "proton_experimental"
                        "config" ""
                        "priority" "250"
                    }
                }
            }
        }
    }
}
EOF

echo "✅ Steam installation complete!"
echo "💡 Launch Steam and enable Proton in Settings > Steam Play"
