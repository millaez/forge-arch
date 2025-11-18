#!/bin/bash
set -e

# MythOS Aesthetic Pillar — Waybar Configuration

echo "📊 Configuring Waybar with Catppuccin theme..."

# Install Waybar (should already be installed)
sudo pacman -S --needed --noconfirm waybar

# Create Waybar config directory
mkdir -p ~/.config/waybar

# Create Waybar config
cat > ~/.config/waybar/config << 'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 34,
    "spacing": 4,
    
    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "network", "cpu", "memory", "temperature", "battery", "tray"],
    
    "hyprland/workspaces": {
        "format": "{icon}",
        "format-icons": {
            "1": "一",
            "2": "二",
            "3": "三",
            "4": "四",
            "5": "五",
            "active": "",
            "default": ""
        },
        "persistent-workspaces": {
            "*": 5
        }
    },
    
    "hyprland/window": {
        "format": "{}",
        "max-length": 50,
        "separate-outputs": true
    },
    
    "clock": {
        "format": "{:%H:%M  %Y-%m-%d}",
        "format-alt": "{:%A, %B %d, %Y}",
        "tooltip-format": "<tt><small>{calendar}</small></tt>",
        "calendar": {
            "mode": "year",
            "mode-mon-col": 3,
            "weeks-pos": "right",
            "on-scroll": 1,
            "format": {
                "months": "<span color='#cba6f7'><b>{}</b></span>",
                "days": "<span color='#cdd6f4'><b>{}</b></span>",
                "weeks": "<span color='#89b4fa'><b>W{}</b></span>",
                "weekdays": "<span color='#f9e2af'><b>{}</b></span>",
                "today": "<span color='#f38ba8'><b><u>{}</u></b></span>"
            }
        }
    },
    
    "cpu": {
        "format": "  {usage}%",
        "tooltip": true,
        "interval": 2
    },
    
    "memory": {
        "format": "  {percentage}%",
        "tooltip-format": "RAM: {used:0.1f}G / {total:0.1f}G"
    },
    
    "temperature": {
        "thermal-zone": 2,
        "critical-threshold": 80,
        "format": "{icon} {temperatureC}°C",
        "format-icons": ["", "", "", "", ""]
    },
    
    "battery": {
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": "  {capacity}%",
        "format-plugged": "  {capacity}%",
        "format-alt": "{icon} {time}",
        "format-icons": ["", "", "", "", ""]
    },
    
    "network": {
        "format-wifi": "  {signalStrength}%",
        "format-ethernet": "  {ipaddr}",
        "format-linked": "  (No IP)",
        "format-disconnected": "  Disconnected",
        "tooltip-format": "{ifname}: {ipaddr}/{cidr}\n{essid}\nStrength: {signalStrength}%"
    },
    
    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-bluetooth": "{icon}  {volume}%",
        "format-bluetooth-muted": "  {icon}",
        "format-muted": "  {volume}%",
        "format-icons": {
            "headphone": "",
            "hands-free": "",
            "headset": "",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["", "", ""]
        },
        "on-click": "pavucontrol"
    },
    
    "tray": {
        "icon-size": 18,
        "spacing": 10
    }
}
EOF

# Create Waybar style (Catppuccin Mocha)
cat > ~/.config/waybar/style.css << 'EOF'
/* MythOS Waybar Style - Catppuccin Mocha */

* {
    font-family: "JetBrains Mono Nerd Font";
    font-size: 13px;
    min-height: 0;
}

window#waybar {
    background-color: rgba(30, 30, 46, 0.9);
    color: #cdd6f4;
    border-bottom: 2px solid #89b4fa;
}

/* Workspaces */
#workspaces button {
    padding: 0 10px;
    color: #cdd6f4;
    background-color: transparent;
    border-radius: 10px;
    margin: 2px;
}

#workspaces button.active {
    color: #1e1e2e;
    background-color: #89b4fa;
}

#workspaces button.urgent {
    background-color: #f38ba8;
}

#workspaces button:hover {
    background-color: #45475a;
    color: #cdd6f4;
}

/* Window title */
#window {
    color: #cba6f7;
    margin: 0 10px;
}

/* Clock */
#clock {
    color: #f9e2af;
    background-color: #313244;
    padding: 0 15px;
    border-radius: 10px;
    margin: 0 5px;
}

/* System modules */
#cpu,
#memory,
#temperature,
#battery,
#network,
#pulseaudio {
    padding: 0 10px;
    margin: 0 2px;
    border-radius: 10px;
}

#cpu {
    color: #f38ba8;
    background-color: #313244;
}

#memory {
    color: #a6e3a1;
    background-color: #313244;
}

#temperature {
    color: #fab387;
    background-color: #313244;
}

#temperature.critical {
    color: #f38ba8;
    background-color: #313244;
}

#battery {
    color: #a6e3a1;
    background-color: #313244;
}

#battery.charging {
    color: #a6e3a1;
}

#battery.warning:not(.charging) {
    color: #f9e2af;
}

#battery.critical:not(.charging) {
    color: #f38ba8;
    animation: blink 0.5s linear infinite alternate;
}

@keyframes blink {
    to {
        background-color: #f38ba8;
        color: #1e1e2e;
    }
}

#network {
    color: #89b4fa;
    background-color: #313244;
}

#network.disconnected {
    color: #f38ba8;
}

#pulseaudio {
    color: #cba6f7;
    background-color: #313244;
}

#pulseaudio.muted {
    color: #6c7086;
}

/* System tray */
#tray {
    background-color: #313244;
    padding: 0 10px;
    margin: 0 5px;
    border-radius: 10px;
}

#tray > .passive {
    -gtk-icon-effect: dim;
}

#tray > .needs-attention {
    -gtk-icon-effect: highlight;
    background-color: #f38ba8;
}
EOF

echo "✅ Waybar configured with Catppuccin theme!"
echo "💡 Waybar will auto-start with Hyprland"
echo "💡 Edit ~/.config/waybar/config to customize modules"
