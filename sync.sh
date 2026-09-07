#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR"

if command -v brew >/dev/null 2>&1; then
    brew_command=$(command -v brew)
elif [ -x /opt/homebrew/bin/brew ]; then
    brew_command=/opt/homebrew/bin/brew
elif [ -x /usr/local/bin/brew ]; then
    brew_command=/usr/local/bin/brew
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ -x /opt/homebrew/bin/brew ]; then
        brew_command=/opt/homebrew/bin/brew
    elif [ -x /usr/local/bin/brew ]; then
        brew_command=/usr/local/bin/brew
    else
        brew_command=$(command -v brew)
    fi
fi

if [ -f "$SCRIPT_DIR/Brewfile" ]; then
    echo "Installing packages from Brewfile..."
    "$brew_command" bundle --file="$SCRIPT_DIR/Brewfile"
fi

ln -sfn "$SCRIPT_DIR/Brewfile" "$HOME/Brewfile"

mkdir -p "$HOME/.config"

for config_name in fish ghostty; do
    rm -rf "$HOME/.config/$config_name"
    ln -s "$SCRIPT_DIR/.config/$config_name" "$HOME/.config/$config_name"
done

rm -rf "$HOME/.tmux.conf"
ln -s "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

# Remove configurations for applications no longer managed by this repo.
for obsolete_config in Code helix nvim zed; do
    rm -rf "$HOME/.config/$obsolete_config"
done

mkdir -p "$HOME/Library/Application Support/VSCodium"
rm -rf "$HOME/Library/Application Support/VSCodium/User"
ln -s "$SCRIPT_DIR/.config/VSCodium/User" "$HOME/Library/Application Support/VSCodium/User"

fish_path=$(command -v fish || true)
if [ -n "$fish_path" ]; then
    if ! grep -qF "$fish_path" /etc/shells 2>/dev/null; then
        echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
    fi
    if [ "${SHELL:-}" != "$fish_path" ]; then
        chsh -s "$fish_path"
    fi
fi

echo "Dotfiles synced from $SCRIPT_DIR"
