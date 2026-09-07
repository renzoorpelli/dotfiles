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

if ! "$brew_command" bundle check --file="$SCRIPT_DIR/Brewfile" >/dev/null 2>&1; then
    echo "Installing missing packages from Brewfile..."
    "$brew_command" bundle install --file="$SCRIPT_DIR/Brewfile"
else
    echo "Homebrew packages are already up to date."
fi

BACKUP_DIR=""

backup_path() {
    local path=$1

    if [ -z "$BACKUP_DIR" ]; then
        mkdir -p "$HOME/.dotfiles-backups"
        BACKUP_DIR=$(mktemp -d "$HOME/.dotfiles-backups/backup.XXXXXX")
        echo "Backing up existing configurations to $BACKUP_DIR"
    fi

    mv "$path" "$BACKUP_DIR/$(basename "$path")"
}

sync_path() {
    local source=$1
    local destination=$2
    local needs_sync=1

    if [ -L "$destination" ]; then
        needs_sync=1
    elif [ -d "$source" ] && [ -d "$destination" ]; then
        if diff -rq "$source" "$destination" >/dev/null 2>&1; then
            needs_sync=0
        fi
    elif [ -f "$source" ] && [ -f "$destination" ]; then
        if cmp -s "$source" "$destination"; then
            needs_sync=0
        fi
    fi

    if [ "$needs_sync" -eq 0 ]; then
        return
    fi

    if [ -e "$destination" ] || [ -L "$destination" ]; then
        backup_path "$destination"
    fi

    mkdir -p "$(dirname "$destination")"
    if [ -d "$source" ]; then
        cp -R "$source" "$destination"
    else
        cp "$source" "$destination"
    fi
}

mkdir -p "$HOME/.config"

sync_path "$SCRIPT_DIR/.config/fish" "$HOME/.config/fish"
sync_path "$SCRIPT_DIR/.config/ghostty" "$HOME/.config/ghostty"
sync_path "$SCRIPT_DIR/.config/VSCodium/User/settings.json" \
    "$HOME/Library/Application Support/VSCodium/User/settings.json"
sync_path "$SCRIPT_DIR/.tmux.conf" "$HOME/.tmux.conf"

# Preserve old configurations instead of deleting them without a backup.
for obsolete_config in Code helix nvim zed; do
    obsolete_path="$HOME/.config/$obsolete_config"
    if [ -e "$obsolete_path" ] || [ -L "$obsolete_path" ]; then
        backup_path "$obsolete_path"
    fi
done

# Remove the legacy Brewfile symlink. Homebrew reads the repository directly.
if [ -L "$HOME/Brewfile" ]; then
    rm "$HOME/Brewfile"
fi

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
