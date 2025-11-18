#!/bin/bash
set -e

# MythOS Developer Pillar — Programming Languages

echo "💻 Installing programming language toolchains..."

# Python
echo "🐍 Installing Python stack..."
sudo pacman -S --needed --noconfirm \
    python \
    python-pip \
    python-pipx \
    python-virtualenv \
    ipython

# Rust
echo "🦀 Installing Rust..."
if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
fi

# Node.js (via nvm for version management)
echo "📦 Installing Node.js..."
if ! command -v nvm &> /dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
fi

# Go
echo "🐹 Installing Go..."
sudo pacman -S --needed --noconfirm go

# Build essentials
echo "🔧 Installing build tools..."
sudo pacman -S --needed --noconfirm \
    base-devel \
    cmake \
    ninja \
    meson \
    clang \
    llvm

# Database clients
echo "🗄️  Installing database tools..."
sudo pacman -S --needed --noconfirm \
    postgresql \
    redis

echo "✅ Programming languages installed!"
echo "💡 Rust: source ~/.cargo/env"
echo "💡 Node: nvm use --lts"
