#!/bin/bash
set -e

# F.O.R.G.E. Aesthetic Pillar — Hyprland Setup
# Part of: forge-arch

echo "🎨 Installing Hyprland and Wayland ecosystem..."

# Determine target user
if [ -n "$SUDO_USER" ]; then
    TARGET_USER="$SUDO_USER"
    TARGET_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    TARGET_USER="$USER"
    TARGET_HOME="$HOME"
fi

# Install Hyprland and core Wayland components
sudo pacman -S --needed --noconfirm \
    hyprland \
    xdg-desktop-portal-hyprland \
    qt5-wayland \
    qt6-wayland \
    polkit-kde-agent

# Install compositor utilities
sudo pacman -S --needed --noconfirm \
    waybar \
    wofi \
    dunst \
    swaybg \
    swaylock \
    swayidle \
    grim \
    slurp \
    wl-clipboard

# Install terminal and file manager
sudo pacman -S --needed --noconfirm \
    alacritty \
    thunar \
    thunar-archive-plugin \
    file-roller

# Install fonts
echo "🔤 Installing fonts..."
sudo pacman -S --needed --noconfirm \
    ttf-jetbrains-mono-nerd \
    ttf-fira-code \
    noto-fonts \
    noto-fonts-emoji

# Install otf-font-awesome or woff2-font-awesome (package name changed)
sudo pacman -S --needed --noconfirm otf-font-awesome 2>/dev/null || \
sudo pacman -S --needed --noconfirm woff2-font-awesome 2>/dev/null || true

# Create config directories
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/.config/hypr"
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/.config/waybar"
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/.config/wofi"
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/.config/alacritty"
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/.config/dunst"

# Create Hyprland config
sudo -u "$TARGET_USER" tee "$TARGET_HOME/.config/hypr/hyprland.conf" > /dev/null << 'EOF'
# F.O.R.G.E. Hyprland Configuration

# Monitor setup (auto-detect)
monitor=,preferred,auto,1

# Startup applications
exec-once = waybar
exec-once = dunst
exec-once = /usr/lib/polkit-kde-authentication-agent-1

# Environment variables
env = XCURSOR_SIZE,24
env = QT_QPA_PLATFORMTHEME,qt5ct

# Input configuration
input {
    kb_layout = us
    follow_mouse = 1
    touchpad {
        natural_scroll = yes
    }
    sensitivity = 0
}

# General appearance
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(cba6f7ee) rgba(89b4faee) 45deg
    col.inactive_border = rgba(585b70aa)
    layout = dwindle
}

# Decoration
decoration {
    rounding = 10
    blur {
        enabled = true
        size = 3
        passes = 1
    }
    shadow {
        enabled = yes
        range = 4
        render_power = 3
        color = rgba(1a1a1aee)
    }
}

# Animations
animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Layouts
dwindle {
    pseudotile = yes
    preserve_split = yes
}

master {
    new_status = master
}

# Window rules
windowrulev2 = float,class:^(pavucontrol)$
windowrulev2 = float,class:^(thunar)$,title:^(File Operation Progress)$

# Keybindings
$mainMod = SUPER

bind = $mainMod, Return, exec, alacritty
bind = $mainMod, Q, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, thunar
bind = $mainMod, V, togglefloating,
bind = $mainMod, D, exec, wofi --show drun
bind = $mainMod, P, pseudo,
bind = $mainMod, J, togglesplit,
bind = $mainMod, F, fullscreen,

# Move focus
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d
bind = $mainMod, H, movefocus, l
bind = $mainMod, L, movefocus, r
bind = $mainMod, K, movefocus, u
bind = $mainMod SHIFT, J, movefocus, d

# Switch workspaces
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move window to workspace
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Mouse bindings
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# Screenshot
bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
bind = SHIFT, Print, exec, grim - | wl-copy

# Volume (if using pipewire/pulseaudio)
bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

# Brightness (for laptops)
bind = , XF86MonBrightnessUp, exec, brightnessctl set +10%
bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-
EOF

echo "✅ Hyprland installed and configured!"
echo ""
echo "💡 To start Hyprland:"
echo "   - Log out and select Hyprland from your display manager"
echo "   - Or from TTY: Hyprland"
echo ""
echo "💡 Key bindings:"
echo "   SUPER + Return    → Terminal (Alacritty)"
echo "   SUPER + D         → App launcher (Wofi)"
echo "   SUPER + Q         → Close window"
echo "   SUPER + E         → File manager (Thunar)"
echo "   SUPER + 1-9       → Switch workspace"
