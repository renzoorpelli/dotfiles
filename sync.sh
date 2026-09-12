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

failed_dependencies=()

for tap in anomalyco/tap hashicorp/tap; do
    if ! "$brew_command" tap-info "$tap" >/dev/null 2>&1; then
        if ! "$brew_command" tap "$tap"; then
            failed_dependencies+=("tap:$tap")
            continue
        fi
    fi
    if ! "$brew_command" trust --tap "$tap"; then
        failed_dependencies+=("tap:$tap")
    fi
done

pi_path="$($brew_command --prefix)/bin/pi"
if [ -L "$pi_path" ]; then
    pi_target=$(readlink "$pi_path" || true)
    case "$pi_target" in
        *@earendil-works/pi-coding-agent*)
            echo "Removing the previous npm Pi link before Homebrew links pi."
            rm "$pi_path"
            ;;
    esac
fi

install_dependency() {
    local kind=$1
    local name=$2

    if "$brew_command" list "--$kind" "$name" >/dev/null 2>&1; then
        echo "Upgrading $kind $name..."
        if ! "$brew_command" upgrade "--$kind" "$name"; then
            failed_dependencies+=("$name")
        fi
    else
        echo "Installing $kind $name..."
        if ! "$brew_command" install "--$kind" "$name"; then
            failed_dependencies+=("$name")
        fi
    fi
}

export HOMEBREW_NO_AUTO_UPDATE=1

while IFS= read -r formula; do
    [ -n "$formula" ] && install_dependency formula "$formula"
done < <("$brew_command" bundle list --formula --file="$SCRIPT_DIR/Brewfile")

while IFS= read -r cask; do
    [ -n "$cask" ] && install_dependency cask "$cask"
done < <("$brew_command" bundle list --cask --file="$SCRIPT_DIR/Brewfile")

echo "Homebrew sync complete."

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
sync_path "$SCRIPT_DIR/.config/nvim" "$HOME/.config/nvim"
sync_path "$SCRIPT_DIR/.local/bin/cheat" "$HOME/.local/bin/cheat"

if command -v tmux >/dev/null 2>&1 && tmux has-session 2>/dev/null; then
    echo "Reloading tmux configuration..."
    tmux source-file "$HOME/.tmux.conf"
fi

# Preserve old configurations instead of deleting them without a backup.
for obsolete_config in Code helix zed; do
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
    if ! grep -qF "$fish_path" /etc/shells 2>/dev/null || [ "${SHELL:-}" != "$fish_path" ]; then
        echo "Configuring Fish as the default shell..."
        echo "Administrator password may be requested once."
        sudo -v

        if ! grep -qF "$fish_path" /etc/shells 2>/dev/null; then
            echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
        fi
        if [ "${SHELL:-}" != "$fish_path" ]; then
            sudo chsh -s "$fish_path" "$USER"
        fi
    fi
fi

echo "Dotfiles synced from $SCRIPT_DIR"

if [ "${#failed_dependencies[@]}" -gt 0 ]; then
    echo "The following dependencies could not be installed or upgraded:" >&2
    printf '  %s\n' "${failed_dependencies[@]}" >&2
    exit 1
fi
