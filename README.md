# 🜂 F.O.R.G.E.

> **Framework for Organized and Reproducible Git-tracked Environments**  
> A metadistribution via provisioning toolkit for Arch Linux
>
> *"Where Chimeras are forged"*

[![License](https://img.shields.io/badge/license-Unlicense-blue.svg)](LICENSE)
[![Arch](https://img.shields.io/badge/provisions-Arch%20Linux-1793D1.svg)](https://archlinux.org/)
[![Maintenance](https://img.shields.io/badge/maintained-yes-green.svg)](https://github.com/millaez/forge-arch/graphs/commit-activity)

---

## What is F.O.R.G.E.?

**F.O.R.G.E. is NOT a Linux distribution.** It is a **metadistribution**—a provisioning toolkit that transforms existing Arch Linux installations into Chimeras: three-natured environments optimized for gaming, development, and aesthetics.

### The Chimera: Three Pillars, One System

| Pillar | Symbol | Domain |
|--------|--------|--------|
| **🦁 Lion** | Gaming | Performance, optimization, play |
| **🐍 Serpent** | Developer | Tools, workflow, productivity |
| **🐐 Goat** | Aesthetic | Beauty, polish, consistency |

### Metadistribution Approach

F.O.R.G.E. doesn't replace Arch—it provisions it:

- ❌ No custom ISO to download
- ❌ No forked packages or repositories
- ✅ Scripted provisioning of vanilla Arch
- ✅ Git-tracked, reproducible configuration
- ✅ Modular pillars you choose

---

## 🚀 Quick Start

### Prerequisites

- **Existing Arch Linux installation** (fresh or established)
- Internet connection
- Basic terminal knowledge

> **Note:** F.O.R.G.E. does NOT provide an ISO. Install Arch Linux first using [archinstall](https://wiki.archlinux.org/title/Archinstall) or the [installation guide](https://wiki.archlinux.org/title/Installation_guide).

### Forge Your Chimera

```bash
# Clone the forge
git clone https://github.com/millaez/forge-arch.git
cd forge-arch

# Forge a complete Chimera (all three pillars)
./forge.py --profile chimera
```

### Modular Provisioning

Forge only what you need:

```bash
# Base system only
./forge.py --bootstrap

# Individual pillars (technical flags)
./forge.py --gaming         # 🦁 Lion
./forge.py --dev            # 🐍 Serpent
./forge.py --aesthetic      # 🐐 Goat

# Or use mythological aliases
./forge.py --lion
./forge.py --serpent
./forge.py --goat

# Combine pillars
./forge.py --gaming --aesthetic
```

---

## 📁 Project Structure

```
forge-arch/
├── forge.py                # Main provisioner
├── bootstrap/              # Base system setup
│   └── arch.sh
├── pillars/                # Modular features
│   ├── gaming/             # 🦁 Lion — Performance & play
│   ├── developer/          # 🐍 Serpent — Tools & workflow
│   └── aesthetic/          # 🐐 Goat — Beauty & polish
├── profiles/               # Pre-configured setups
│   ├── chimera.yaml        # Full three-pillar default
│   ├── lion.yaml           # Gaming-focused
│   ├── serpent.yaml        # Developer-focused
│   └── goat.yaml           # Aesthetic-focused
├── traits/                 # Reusable behaviors
└── core/                   # Python orchestration
```

---

## 🎯 Profiles

### Chimera (Default)

The complete three-natured beast with all pillars:

```bash
./forge.py --profile chimera
```

### Single-Pillar Profiles

```bash
./forge.py --profile lion      # Gaming only
./forge.py --profile serpent   # Developer only
./forge.py --profile goat      # Aesthetic only
```

### Create Your Own

```yaml
# profiles/custom.yaml
name: "Custom"
description: "My personalized Chimera"

pillars:
  gaming:
    - steam
    - mangohud
  developer:
    - shell
    - git
  aesthetic:
    - hyprland
```

---

## ✨ Features

### 🦁 Lion Pillar (Gaming)

- **Performance Kernel** — CachyOS with BORE scheduler
- **GPU Auto-Detection** — NVIDIA, AMD, or Intel drivers
- **Gaming Stack** — Steam, Lutris, Proton-GE, MangoHud, GameMode
- **Optimizations** — CPU governor, kernel parameters, compositor tweaks

### 🐍 Serpent Pillar (Developer)

- **Modern Shell** — Starship prompt, zoxide, fzf, modern CLI tools
- **Editor Setup** — Neovim with LSP (or alternatives)
- **Language Toolchains** — Python, Rust, Node.js, Go
- **Containers** — Distrobox + Podman for isolated environments
- **Version Control** — Git with delta, lazygit

### 🐐 Goat Pillar (Aesthetic)

- **Compositor** — Hyprland (Wayland) or alternatives
- **System Theme** — Catppuccin (default) or alternatives
- **UI Components** — Waybar, Wofi, Dunst
- **Fonts** — JetBrains Mono Nerd Font, quality typography
- **Consistency** — GTK, Qt, terminals all themed

---

## 🔧 Design Philosophy

### Categories Over Apps

F.O.R.G.E. recommends **tool categories**, not specific applications:

| Category | Default | Alternatives |
|----------|---------|--------------|
| Terminal | Alacritty | Kitty, WezTerm, Foot |
| Editor | Neovim | VS Code, Helix, Vim |
| Compositor | Hyprland | Sway, i3, Niri |
| Theme | Catppuccin | Nord, Dracula, Gruvbox |

Defaults are **suggestions**, not requirements. Swap freely.

### Reproducibility First

Every F.O.R.G.E. provisioning is:

- **Scriptable** — No manual steps required
- **Idempotent** — Safe to re-run
- **Git-tracked** — Version controlled configs
- **Documented** — Every script explains itself

---

## 🛠️ System Requirements

### Minimum

- **Base:** Arch Linux installation
- **CPU:** x86_64 processor
- **RAM:** 4GB (8GB recommended)
- **Storage:** 30GB free space

### Recommended

- **CPU:** Modern multi-core (4+ cores)
- **RAM:** 16GB+
- **Storage:** 100GB+ NVMe SSD
- **GPU:** Dedicated NVIDIA or AMD

---

## 📚 Documentation

- [Installation Guide](docs/installation.md)
- [Gaming Setup](docs/gaming.md)
- [Developer Workflow](docs/development.md)
- [Customization](docs/customization.md)
- [Troubleshooting](docs/troubleshooting.md)

---

## 🤝 Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Ways to Contribute

- 🐛 Report bugs and issues
- 💡 Suggest improvements
- 📝 Improve documentation
- 🔧 Add pillar scripts
- ⭐ Star the repository

---

## 📜 License

**Unlicense (Public Domain)** — See [LICENSE](LICENSE)

---

## 🙏 Acknowledgments

- **Arch Linux** — The foundation
- **CachyOS** — Performance kernels
- **Catppuccin** — Beautiful theming
- **Hyprland** — Excellent compositor
- All open-source projects that make F.O.R.G.E. possible

---

<p align="center">
  <strong>🜂 F.O.R.G.E.</strong><br>
  <em>Framework for Organized and Reproducible Git-tracked Environments</em><br><br>
  🦁 Gaming &nbsp;│&nbsp; 🐍 Developer &nbsp;│&nbsp; 🐐 Aesthetic<br><br>
  <strong>"Where Chimeras are forged"</strong>
</p>
