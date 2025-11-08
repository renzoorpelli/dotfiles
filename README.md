# Dotfiles

Cross-platform dotfiles configuration for macOS and Ubuntu with automated setup.

## Structure

```
dotfiles/
├── .config/
│   ├── ghostty/           # Terminal emulator config
│   └── fish/              # Fish shell configuration
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
- Detect your OS (macOS/Ubuntu)
- **macOS:** Install Homebrew and packages from Brewfile
- **Ubuntu:** Install Fish shell (other packages need manual installation)
- Symlink all config files to `~/.config/`
- Symlink Brewfile to `~/Brewfile` (macOS only)
- Set Fish as your default shells