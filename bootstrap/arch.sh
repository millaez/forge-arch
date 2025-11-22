#!/bin/bash
set -e

# F.O.R.G.E. Bootstrap — Arch Base System Setup
# Part of: forge-arch

echo "
🜂 F.O.R.G.E. Bootstrap — Base System
═══════════════════════════════════════
"

# Must run as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ This script must be run as root"
    echo "   Usage: sudo bash bootstrap/arch.sh"
    exit 1
fi

# Determine target user
if [ -n "$SUDO_USER" ]; then
    TARGET_USER="$SUDO_USER"
    TARGET_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    echo "⚠️  Running as root without sudo"
    echo "   Some user-specific configurations will be skipped"
    TARGET_USER="root"
    TARGET_HOME="/root"
fi

echo "📋 Target user: $TARGET_USER"
echo "📋 Target home: $TARGET_HOME"
echo ""

# Update system
echo "📦 Updating system packages..."
pacman -Syu --noconfirm

# Install essential base packages
echo "📦 Installing base packages..."
pacman -S --needed --noconfirm \
    base-devel \
    git \
    wget \
    curl \
    vim \
    neovim \
    htop \
    btop \
    fastfetch \
    unzip \
    zip \
    man-db \
    man-pages \
    rsync \
    python \
    python-pip \
    python-yaml

# Enable multilib (for 32-bit support, needed for gaming)
echo "📦 Enabling multilib repository..."
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "" >> /etc/pacman.conf
    echo "[multilib]" >> /etc/pacman.conf
    echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    pacman -Sy --noconfirm
fi

# Optimize pacman
echo "⚡ Optimizing pacman..."
sed -i 's/#ParallelDownloads.*/ParallelDownloads = 5/' /etc/pacman.conf
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf

# Install yay (AUR helper) if not present
if ! command -v yay &> /dev/null; then
    echo "📦 Installing yay (AUR helper)..."
    
    # yay must be built as non-root user
    if [ "$TARGET_USER" != "root" ]; then
        sudo -u "$TARGET_USER" bash << EOF
cd /tmp
rm -rf yay
git clone https://aur.archlinux.org/yay-bin.git yay
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay
EOF
    else
        echo "⚠️  Cannot install yay as root. Skipping."
        echo "   Install manually after creating a user account."
    fi
fi

# Install common utilities
echo "📦 Installing common utilities..."
pacman -S --needed --noconfirm \
    bash-completion \
    fd \
    ripgrep \
    bat \
    eza \
    zoxide \
    fzf \
    stow \
    reflector

# Update mirrorlist with fastest mirrors
echo "🌐 Updating mirrorlist..."
reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist --protocol https 2>/dev/null || true

# Set up directory structure
echo "📁 Creating directory structure..."
if [ "$TARGET_USER" != "root" ]; then
    sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/.config"
    sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/repos"
    sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/.local/bin"
fi

# Basic shell improvements for target user
if [ "$TARGET_USER" != "root" ]; then
    BASHRC_FILE="$TARGET_HOME/.bashrc"
    if ! grep -q "# F.O.R.G.E. Shell Enhancements" "$BASHRC_FILE" 2>/dev/null; then
        sudo -u "$TARGET_USER" tee -a "$BASHRC_FILE" > /dev/null << 'EOF'

# F.O.R.G.E. Shell Enhancements
alias ls='eza --icons'
alias ll='eza -la --icons'
alias cat='bat --paging=never'
alias grep='rg'
alias find='fd'

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"
EOF
    fi
fi

echo "
✅ F.O.R.G.E. Bootstrap Complete!
═══════════════════════════════════════

Next steps:
  ./forge.py --gaming      # 🦁 Forge gaming pillar
  ./forge.py --dev         # 🐍 Forge developer pillar
  ./forge.py --aesthetic   # 🐐 Forge aesthetic pillar
  ./forge.py --profile chimera  # Forge all pillars

🜂 Where Chimeras are forged
"
