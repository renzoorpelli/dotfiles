#!/bin/bash

set -e

if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! command -v fish &> /dev/null; then
    brew install fish
fi

if [ -f "Brewfile" ]; then
    echo "Installing packages from Brewfile..."
    brew bundle --file="$PWD/Brewfile"
fi

ln -sf "$PWD/Brewfile" "$HOME/Brewfile"

mkdir -p "$HOME/.config"

for config_dir in .config/*/; do
    if [ -d "$config_dir" ]; then
        config_name=$(basename "$config_dir")
        # VS Code has a special location on macOS
        if [ "$config_name" = "Code" ]; then
            mkdir -p "$HOME/Library/Application Support/Code"
            ln -sf "$PWD/$config_dir/User" "$HOME/Library/Application Support/Code/User"
        else
            ln -sf "$PWD/$config_dir" "$HOME/.config/"
        fi
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

echo "done"
