#!/bin/bash
set -e

# MythOS Aesthetic Pillar — Catppuccin Theme Setup

echo "🎨 Installing Catppuccin theme system-wide..."

# Install GTK theme
echo "📦 Installing GTK themes..."
yay -S --needed --noconfirm \
    catppuccin-gtk-theme-mocha \
    papirus-icon-theme \
    catppuccin-cursors-mocha

# Install additional themes
sudo pacman -S --needed --noconfirm \
    gtk-engine-murrine \
    gtk-engines

# Apply GTK theme
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0

cat > ~/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=Catppuccin-Mocha-Standard-Blue-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Inter 10
gtk-cursor-theme-name=Catppuccin-Mocha-Dark-Cursors
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintslight
gtk-xft-rgba=rgb
EOF

cp ~/.config/gtk-3.0/settings.ini ~/.config/gtk-4.0/settings.ini

# Set cursor theme
mkdir -p ~/.icons/default
cat > ~/.icons/default/index.theme << 'EOF'
[Icon Theme]
Inherits=Catppuccin-Mocha-Dark-Cursors
EOF

# Install Qt theme
echo "📦 Installing Qt themes..."
sudo pacman -S --needed --noconfirm \
    kvantum \
    qt5ct \
    qt6ct

yay -S --needed --noconfirm \
    catppuccin-kvantum-theme-git

# Configure Kvantum
mkdir -p ~/.config/Kvantum
cat > ~/.config/Kvantum/kvantum.kvconfig << 'EOF'
[General]
theme=Catppuccin-Mocha-Blue
EOF

# Set Qt environment variables
if ! grep -q "QT_QPA_PLATFORMTHEME" ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc << 'EOF'

# Qt theme configuration
export QT_QPA_PLATFORMTHEME=kvantum
export QT_STYLE_OVERRIDE=kvantum
EOF
fi

# Install Alacritty Catppuccin theme
echo "📦 Configuring Alacritty theme..."
mkdir -p ~/.config/alacritty/themes

curl -o ~/.config/alacritty/themes/catppuccin-mocha.toml \
    https://raw.githubusercontent.com/catppuccin/alacritty/main/catppuccin-mocha.toml

# Create/update Alacritty config
if [ ! -f ~/.config/alacritty/alacritty.toml ]; then
    cat > ~/.config/alacritty/alacritty.toml << 'EOF'
# MythOS Alacritty Configuration

import = ["~/.config/alacritty/themes/catppuccin-mocha.toml"]

[font]
size = 12

[font.normal]
family = "JetBrains Mono Nerd Font"
style = "Regular"

[font.bold]
family = "JetBrains Mono Nerd Font"
style = "Bold"

[font.italic]
family = "JetBrains Mono Nerd Font"
style = "Italic"

[window]
opacity = 0.95
padding = { x = 10, y = 10 }
decorations = "None"

[cursor]
style = { shape = "Block", blinking = "On" }
EOF
fi

# Install Neovim Catppuccin theme
echo "📦 Configuring Neovim theme..."
mkdir -p ~/.config/nvim/lua/plugins

cat > ~/.config/nvim/lua/plugins/catppuccin.lua << 'EOF'
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
EOF

echo "✅ Catppuccin theme installed system-wide!"
echo "💡 Log out and back in for all changes to take effect"
echo "💡 Use 'kvantummanager' to fine-tune Qt theme"
