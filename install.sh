#!/bin/bash

set -e

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo "Unsupported OS"
    exit 1
fi

echo "Detected OS: $OS"

# Install dependencies
if [ "$OS" = "macos" ]; then
    # Install Homebrew
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Install fish
    if ! command -v fish &> /dev/null; then
        brew install fish
    fi
    
    # Install packages from Brewfile
    if [ -f "Brewfile" ]; then
        echo "Installing packages from Brewfile..."
        brew bundle --file="$PWD/Brewfile"
    fi
    
    # Symlink Brewfile
    ln -sf "$PWD/Brewfile" "$HOME/Brewfile"
elif [ "$OS" = "linux" ]; then
    # Install fish
    if ! command -v fish &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y fish
    fi
fi

# Symlink config files
echo "Setting up dotfiles..."
mkdir -p "$HOME/.config"

for config_dir in .config/*/; do
    if [ -d "$config_dir" ]; then
        ln -sf "$PWD/$config_dir" "$HOME/.config/"
    fi
done

# Change default shell to fish
if command -v fish &> /dev/null; then
    fish_path=$(which fish)
    if ! grep -q "$fish_path" /etc/shells 2>/dev/null; then
        echo "$fish_path" | sudo tee -a /etc/shells > /dev/null
    fi
    if [ "$SHELL" != "$fish_path" ]; then
        chsh -s "$fish_path"
    fi
fi

echo "Done! Restart your terminal."
