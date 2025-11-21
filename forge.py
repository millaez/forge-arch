#!/usr/bin/env python3
"""
F.O.R.G.E. — Framework for Organized and Reproducible Git-tracked Environments

Main provisioner for the forge-arch metadistribution toolkit.
Transforms Arch Linux systems into Chimeras.

"Where Chimeras are forged"
"""

import argparse
import subprocess
import sys
import yaml
from pathlib import Path
from typing import List, Dict, Optional

VERSION = "1.0.0"

# Terminal colors
class Colors:
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    MAGENTA = '\033[95m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    BOLD = '\033[1m'
    DIM = '\033[2m'
    RESET = '\033[0m'

def print_banner():
    """Print the F.O.R.G.E. welcome banner."""
    c = Colors
    print(f"""
{c.RED}╔═══════════════════════════════════════════════════════════════╗{c.RESET}
{c.RED}║{c.RESET}                                                               {c.RED}║{c.RESET}
{c.RED}║{c.RESET}     🜂  {c.BOLD}{c.RED}F{c.RESET}{c.DIM}.{c.RESET}{c.BOLD}{c.RED}O{c.RESET}{c.DIM}.{c.RESET}{c.BOLD}{c.RED}R{c.RESET}{c.DIM}.{c.RESET}{c.BOLD}{c.RED}G{c.RESET}{c.DIM}.{c.RESET}{c.BOLD}{c.RED}E{c.RESET}{c.DIM}.{c.RESET}                                             {c.RED}║{c.RESET}
{c.RED}║{c.RESET}                                                               {c.RED}║{c.RESET}
{c.RED}║{c.RESET}     {c.BOLD}F{c.RESET}ramework {c.DIM}for{c.RESET} {c.BOLD}O{c.RESET}rganized {c.DIM}and{c.RESET} {c.BOLD}R{c.RESET}eproducible                  {c.RED}║{c.RESET}
{c.RED}║{c.RESET}     {c.BOLD}G{c.RESET}it-tracked {c.BOLD}E{c.RESET}nvironments                                  {c.RED}║{c.RESET}
{c.RED}║{c.RESET}                                                               {c.RED}║{c.RESET}
{c.RED}║{c.RESET}     🦁 {c.YELLOW}Gaming{c.RESET}  │  🐍 {c.GREEN}Developer{c.RESET}  │  🐐 {c.MAGENTA}Aesthetic{c.RESET}                {c.RED}║{c.RESET}
{c.RED}║{c.RESET}                                                               {c.RED}║{c.RESET}
{c.RED}║{c.RESET}     {c.DIM}"Where Chimeras are forged"{c.RESET}                               {c.RED}║{c.RESET}
{c.RED}║{c.RESET}                                                               {c.RED}║{c.RESET}
{c.RED}╚═══════════════════════════════════════════════════════════════╝{c.RESET}
""")


class ForgeProvisioner:
    """Main provisioner for F.O.R.G.E. metadistribution toolkit."""
    
    def __init__(self, repo_root: Path):
        self.repo_root = repo_root
        self.bootstrap_dir = repo_root / "bootstrap"
        self.pillars_dir = repo_root / "pillars"
        self.profiles_dir = repo_root / "profiles"
        self.traits_dir = repo_root / "traits"
    
    def run_script(self, script_path: Path, description: str = None) -> bool:
        """Execute a shell script with error handling."""
        if not script_path.exists():
            print(f"{Colors.RED}❌ Script not found: {script_path}{Colors.RESET}")
            return False
        
        desc = description or script_path.name
        print(f"{Colors.CYAN}🔧 Forging: {desc}{Colors.RESET}")
        
        try:
            result = subprocess.run(
                ["bash", str(script_path)],
                check=True,
                text=True
            )
            print(f"{Colors.GREEN}✅ {desc} complete{Colors.RESET}")
            return True
        except subprocess.CalledProcessError as e:
            print(f"{Colors.RED}❌ {desc} failed{Colors.RESET}")
            return False
    
    def load_profile(self, profile_name: str) -> Dict:
        """Load a YAML profile configuration."""
        profile_path = self.profiles_dir / f"{profile_name}.yaml"
        
        if not profile_path.exists():
            print(f"{Colors.RED}❌ Profile not found: {profile_name}{Colors.RESET}")
            sys.exit(1)
        
        with open(profile_path) as f:
            return yaml.safe_load(f)
    
    def load_trait(self, trait_name: str) -> Dict:
        """Load a reusable trait set."""
        trait_path = self.traits_dir / f"{trait_name}.yaml"
        
        if not trait_path.exists():
            print(f"{Colors.YELLOW}⚠️  Trait not found: {trait_name}{Colors.RESET}")
            return {}
        
        with open(trait_path) as f:
            return yaml.safe_load(f)
    
    def bootstrap(self) -> bool:
        """Run base Arch system setup."""
        print(f"\n{Colors.BOLD}🜂 F.O.R.G.E. Bootstrap — Base System{Colors.RESET}")
        print("=" * 50)
        
        arch_bootstrap = self.bootstrap_dir / "arch.sh"
        return self.run_script(arch_bootstrap, "Arch base system setup")
    
    def provision_pillar(self, pillar: str, scripts: List[str] = None) -> bool:
        """Provision a specific pillar."""
        pillar_dir = self.pillars_dir / pillar
        
        if not pillar_dir.exists():
            print(f"{Colors.RED}❌ Pillar not found: {pillar}{Colors.RESET}")
            return False
        
        # Pillar branding
        pillar_info = {
            'gaming': ('🦁', 'Lion', Colors.YELLOW),
            'developer': ('🐍', 'Serpent', Colors.GREEN),
            'aesthetic': ('🐐', 'Goat', Colors.MAGENTA)
        }
        
        symbol, name, color = pillar_info.get(pillar, ('🔧', pillar.title(), Colors.WHITE))
        
        print(f"\n{Colors.BOLD}{symbol} Forging {color}{name}{Colors.RESET} {Colors.BOLD}Pillar ({pillar}){Colors.RESET}")
        print("=" * 50)
        
        # If specific scripts provided, run those; otherwise run all
        if scripts:
            script_paths = [pillar_dir / f"{s}.sh" for s in scripts]
        else:
            script_paths = sorted(pillar_dir.glob("*.sh"))
        
        success = True
        for script in script_paths:
            if script.exists():
                if not self.run_script(script):
                    success = False
                    if not self.confirm_continue():
                        return False
            else:
                print(f"{Colors.YELLOW}⚠️  Script not found: {script.name}{Colors.RESET}")
        
        return success
    
    def provision_from_profile(self, profile_name: str) -> bool:
        """Provision system based on a YAML profile."""
        print(f"\n{Colors.CYAN}📋 Loading Profile: {profile_name}{Colors.RESET}")
        profile = self.load_profile(profile_name)
        
        # Load any traits referenced in profile
        traits = profile.get("traits", [])
        for trait in traits:
            trait_data = self.load_trait(trait)
            for key, value in trait_data.items():
                if key not in profile:
                    profile[key] = value
        
        # Run bootstrap if requested
        if profile.get("bootstrap", True):
            if not self.bootstrap():
                if not self.confirm_continue():
                    return False
        
        # Provision each pillar
        pillars = profile.get("pillars", {})
        for pillar, scripts in pillars.items():
            if isinstance(scripts, list):
                if not self.provision_pillar(pillar, scripts):
                    if not self.confirm_continue():
                        return False
            elif scripts == "all" or scripts is True:
                if not self.provision_pillar(pillar):
                    if not self.confirm_continue():
                        return False
        
        self.print_completion()
        return True
    
    def confirm_continue(self) -> bool:
        """Ask user if they want to continue after an error."""
        response = input(f"\n{Colors.YELLOW}⚠️  Continue anyway? [y/N]: {Colors.RESET}").strip().lower()
        return response == 'y'
    
    def print_completion(self):
        """Print completion message."""
        print(f"""
{Colors.GREEN}╔═══════════════════════════════════════════════════════════════╗
║                                                               ║
║     🜂  {Colors.BOLD}Chimera Forged Successfully!{Colors.RESET}{Colors.GREEN}                          ║
║                                                               ║
║     Your Arch system has been transformed.                    ║
║                                                               ║
║     🦁 Gaming  │  🐍 Developer  │  🐐 Aesthetic                ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝{Colors.RESET}
""")


def main():
    parser = argparse.ArgumentParser(
        description="F.O.R.G.E. — Framework for Organized and Reproducible Git-tracked Environments",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  ./forge.py --profile chimera    Forge complete Chimera (all pillars)
  ./forge.py --gaming             Forge gaming pillar only
  ./forge.py --lion               Same as --gaming (mythological alias)
  ./forge.py --dev --aesthetic    Forge developer and aesthetic pillars

Profiles:
  chimera    All three pillars (Lion + Serpent + Goat)
  lion       Gaming only
  serpent    Developer only
  goat       Aesthetic only

"Where Chimeras are forged"
        """
    )
    
    parser.add_argument(
        "--version", "-v",
        action="version",
        version=f"F.O.R.G.E. v{VERSION}"
    )
    
    parser.add_argument(
        "--profile", "-p",
        help="Load a profile (e.g., 'chimera')",
        type=str
    )
    
    parser.add_argument(
        "--bootstrap", "-b",
        action="store_true",
        help="Run base Arch bootstrap only"
    )
    
    # Technical pillar flags
    parser.add_argument(
        "--gaming",
        action="store_true",
        help="Forge gaming pillar (Lion)"
    )
    
    parser.add_argument(
        "--dev",
        action="store_true",
        help="Forge developer pillar (Serpent)"
    )
    
    parser.add_argument(
        "--aesthetic",
        action="store_true",
        help="Forge aesthetic pillar (Goat)"
    )
    
    # Mythological aliases
    parser.add_argument(
        "--lion",
        action="store_true",
        help="Alias for --gaming"
    )
    
    parser.add_argument(
        "--serpent",
        action="store_true",
        help="Alias for --dev"
    )
    
    parser.add_argument(
        "--goat",
        action="store_true",
        help="Alias for --aesthetic"
    )
    
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be done without executing"
    )
    
    args = parser.parse_args()
    
    # Handle mythological aliases
    if args.lion:
        args.gaming = True
    if args.serpent:
        args.dev = True
    if args.goat:
        args.aesthetic = True
    
    # Determine repo root
    repo_root = Path(__file__).parent.resolve()
    forge = ForgeProvisioner(repo_root)
    
    # Print banner
    print_banner()
    
    # Dry run notice
    if args.dry_run:
        print(f"{Colors.YELLOW}🔍 DRY RUN MODE — No changes will be made{Colors.RESET}\n")
    
    # Profile-based provisioning
    if args.profile:
        forge.provision_from_profile(args.profile)
        return
    
    # Manual flag-based provisioning
    ran_something = False
    
    if args.bootstrap:
        forge.bootstrap()
        ran_something = True
    
    if args.gaming:
        forge.provision_pillar("gaming")
        ran_something = True
    
    if args.dev:
        forge.provision_pillar("developer")
        ran_something = True
    
    if args.aesthetic:
        forge.provision_pillar("aesthetic")
        ran_something = True
    
    if ran_something:
        forge.print_completion()
    else:
        # No flags provided, show help
        parser.print_help()


if __name__ == "__main__":
    main()
