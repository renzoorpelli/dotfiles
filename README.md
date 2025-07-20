# Dotfiles

Cross-platform dotfiles configuration for macOS and Ubuntu with automated setup.

## Structure

```
dotfiles/
├── .config/
│   ├── ghostty/           # Terminal emulator config
│   ├── starship.toml      # Shell prompt configuration  
│   └── fish/              # Fish shell configuration
├── install.sh             # Automated setup script
└── README.md              # This file
```

**Note**: Neovim configuration uses [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and is cloned fresh during installation.

## Installation

1. Clone this repository to your home directory:
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

2. Run the installation script:
```bash
./install.sh
```

The script will:
- Detect your OS (macOS/Ubuntu)
- Install required dependencies (Neovim, Starship, Stow, Ghostty, Fish)
- Clone kickstart.nvim configuration
- Symlink dotfiles using GNU Stow
- Set Fish as your default shell

## What I use

- **Ghostty**
- **Starship**
- **Fish**
- **Neovim**