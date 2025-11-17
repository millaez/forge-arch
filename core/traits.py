#!/usr/bin/env python3
"""Load and apply trait definitions"""
import yaml
from pathlib import Path

class TraitLoader:
    def __init__(self, traits_dir='traits'):
        self.traits_dir = Path(traits_dir)
    
    def load_trait(self, trait_name):
        """Load trait from YAML file"""
        trait_file = self.traits_dir / f"{trait_name}.yaml"
        if trait_file.exists():
            with open(trait_file) as f:
                return yaml.safe_load(f)
        return None
    
    def apply_trait(self, trait_name):
        """Apply trait packages and configurations"""
        trait = self.load_trait(trait_name)
        if not trait:
            return False
        
        # Install packages
        for pkg in trait.get('packages', {}).get('arch', []):
            subprocess.run(f'pacman -S --noconfirm --needed {pkg}', shell=True)
        
        return True
