# Dotfiles

Personal dotfiles configuration for macOS with automated setup.

## Structure

```
dotfiles/
├── .config/
│   ├── VSCodium/User/     # VSCodium configuration
│   ├── fish/              # Fish shell configuration
│   ├── ghostty/           # Ghostty terminal config
├── .tmux.conf              # Tmux configuration
├── .gitignore             # Ignore sensitive and generated files
├── Brewfile               # Homebrew packages (macOS)
├── sync.sh                # Install applications and sync configurations
└── README.md              # This file
```

## Installation

1. Clone this repository:
```bash
git clone git@github.com:renzoorpelli/dotfiles
cd dotfiles
```

2. Install applications and sync configurations:
```bash
./sync.sh
```

When the repository has new changes, run `git pull` from the repository and
then run `./sync.sh` again.

The script will:
- Install Homebrew (if not already installed)
- Install packages from Brewfile, including Fish, Tmux, Ghostty and VSCodium
- Copy managed config files to `~/.config/`
- Copy tmux configuration to `~/.tmux.conf`
- Copy VSCodium settings to `~/Library/Application Support/VSCodium/User/`
- Back up replaced configurations to `~/.dotfiles-backups/`
- Set Fish as your default shell

The sync script does not create symlinks. The repository remains independent
from files edited in `$HOME`, and obsolete configurations are backed up rather
than deleted. It does not uninstall applications.

## What I use

- **Ghostty** - Terminal emulator
- **Fish** - Shell
- **VSCodium** - Code editor
- **Tmux** - Terminal multiplexer
- **MacShot** - Screenshot and screen recording tool
