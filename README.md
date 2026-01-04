# Dotfiles

Personal dotfiles configuration for macOS with automated setup.

## Structure

```
dotfiles/
├── .config/
│   ├── Code/User/         # VS Code configuration
│   ├── fish/              # Fish shell configuration
│   ├── ghostty/           # Terminal emulator config
│   └── nvim/              # Neovim configuration
├── .gitignore             # Ignore sensitive and generated files
├── Brewfile               # Homebrew packages (macOS)
├── install.sh             # Automated setup script
└── README.md              # This file
```

## Installation

1. Clone this repository to your home directory:
```bash
git clone https://github.com/renzoorpelli/dotfiles ~/dotfiles
cd ~/dotfiles
```

2. Run the installation script:
```bash
./install.sh
```

The script will:
- Install Homebrew (if not already installed)
- Install Fish shell and packages from Brewfile
- Symlink all config files to `~/.config/`
- Symlink VS Code config to `~/Library/Application Support/Code/User/`
- Symlink Brewfile to `~/Brewfile`
- Set Fish as your default shell

## What I use

- **Ghostty** - Terminal emulator
- **Fish** - Shell
- **Neovim** - Primary code editor
- **VS Code** - Secondary code editor