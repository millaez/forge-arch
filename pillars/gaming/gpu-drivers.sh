#!/bin/bash
set -e

# F.O.R.G.E. Gaming Pillar — GPU Driver Setup
# Part of: forge-arch

echo "🎮 Detecting and installing GPU drivers..."

# Detect GPU vendor
detect_gpu() {
    if lspci | grep -qi "nvidia"; then
        echo "nvidia"
    elif lspci | grep -qiE "amd|radeon"; then
        echo "amd"
    elif lspci | grep -qi "intel.*graphics"; then
        echo "intel"
    else
        echo "unknown"
    fi
}

GPU_VENDOR=$(detect_gpu)
echo "🔍 Detected GPU vendor: $GPU_VENDOR"

case "$GPU_VENDOR" in
    nvidia)
        echo "📦 Installing NVIDIA drivers..."
        
        # Check if running a custom kernel
        KERNEL=$(uname -r)
        if [[ "$KERNEL" == *"cachyos"* ]] || [[ "$KERNEL" == *"zen"* ]] || [[ "$KERNEL" == *"lts"* ]]; then
            echo "   Detected custom kernel: $KERNEL"
            echo "   Using nvidia-dkms for compatibility"
            sudo pacman -S --needed --noconfirm \
                nvidia-dkms \
                nvidia-utils \
                lib32-nvidia-utils \
                nvidia-settings \
                vulkan-icd-loader \
                lib32-vulkan-icd-loader
        else
            sudo pacman -S --needed --noconfirm \
                nvidia \
                nvidia-utils \
                lib32-nvidia-utils \
                nvidia-settings \
                vulkan-icd-loader \
                lib32-vulkan-icd-loader
        fi
        
        # Enable DRM kernel mode setting for Wayland
        if ! grep -q "nvidia-drm.modeset=1" /etc/default/grub 2>/dev/null; then
            echo "   Enabling NVIDIA DRM modeset for Wayland..."
            sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 nvidia-drm.modeset=1"/' /etc/default/grub
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi
        
        # Create pacman hook for NVIDIA driver updates
        sudo mkdir -p /etc/pacman.d/hooks
        sudo tee /etc/pacman.d/hooks/nvidia.hook > /dev/null << 'EOF'
[Trigger]
Operation=Install
Operation=Upgrade
Operation=Remove
Type=Package
Target=nvidia
Target=nvidia-dkms
Target=linux
Target=linux-cachyos
Target=linux-zen
Target=linux-lts

[Action]
Description=Updating NVIDIA module in initcpio
Depends=mkinitcpio
When=PostTransaction
NeedsTargets
Exec=/bin/sh -c 'while read -r trg; do case $trg in linux*) exit 0; esac; done; /usr/bin/mkinitcpio -P'
EOF
        ;;
        
    amd)
        echo "📦 Installing AMD drivers..."
        sudo pacman -S --needed --noconfirm \
            mesa \
            lib32-mesa \
            vulkan-radeon \
            lib32-vulkan-radeon \
            vulkan-icd-loader \
            lib32-vulkan-icd-loader \
            libva-mesa-driver \
            lib32-libva-mesa-driver \
            mesa-vdpau \
            lib32-mesa-vdpau
        
        # Optional: AMD GPU control
        echo "💡 For AMD GPU overclocking/monitoring, install 'corectrl' from AUR"
        ;;
        
    intel)
        echo "📦 Installing Intel drivers..."
        sudo pacman -S --needed --noconfirm \
            mesa \
            lib32-mesa \
            vulkan-intel \
            lib32-vulkan-intel \
            vulkan-icd-loader \
            lib32-vulkan-icd-loader \
            intel-media-driver \
            libva-intel-driver
        ;;
        
    *)
        echo "⚠️  Could not detect GPU vendor!"
        echo "   Installing generic Mesa drivers..."
        sudo pacman -S --needed --noconfirm \
            mesa \
            lib32-mesa \
            vulkan-icd-loader \
            lib32-vulkan-icd-loader
        
        echo ""
        echo "Please manually verify your GPU:"
        lspci | grep -iE "vga|3d|display"
        ;;
esac

# Install common Vulkan tools
echo "📦 Installing Vulkan tools..."
sudo pacman -S --needed --noconfirm \
    vulkan-tools

echo ""
echo "✅ GPU drivers installed!"
echo "💡 Verify with: vulkaninfo --summary"
echo "💡 A reboot is recommended after driver installation"
