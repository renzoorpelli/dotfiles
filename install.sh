#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            OS="ubuntu"
        else
            print_error "Unsupported Linux distribution. This script supports Ubuntu only."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        print_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    print_status "Detected OS: $OS"
}

# Install dependencies based on OS
install_dependencies() {
    print_status "Installing dependencies..."
    
    case $OS in
        "ubuntu")
            # Update package list
            sudo apt-get update
            
            # Install dependencies
            if ! command -v git &> /dev/null; then
                print_status "Installing git..."
                sudo apt-get install -y git
            fi
            
            if ! command -v curl &> /dev/null; then
                print_status "Installing curl..."
                sudo apt-get install -y curl
            fi
            
            if ! command -v stow &> /dev/null; then
                print_status "Installing stow..."
                sudo apt-get install -y stow
            fi
            
            if ! command -v fish &> /dev/null; then
                print_status "Installing fish shell..."
                sudo apt-get install -y fish
            fi
            
            # Install Neovim from official repository
            if ! command -v nvim &> /dev/null; then
                print_status "Installing Neovim..."
                sudo apt-get install -y software-properties-common
                sudo add-apt-repository ppa:neovim-ppa/unstable -y
                sudo apt-get update
                sudo apt-get install -y neovim
            fi
            
            # Install Starship
            if ! command -v starship &> /dev/null; then
                print_status "Installing Starship..."
                curl -sS https://starship.rs/install.sh | sh -s -- -y
            fi
            
            # Install Ghostty (if available)
            if ! command -v ghostty &> /dev/null; then
                print_warning "Ghostty is not available via package manager on Ubuntu. Please install manually from https://ghostty.org/"
            fi
            ;;
            
        "macos")
            # Install Homebrew if not present
            if ! command -v brew &> /dev/null; then
                print_status "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            
            # Install dependencies
            if ! command -v stow &> /dev/null; then
                print_status "Installing stow..."
                brew install stow
            fi
            
            if ! command -v fish &> /dev/null; then
                print_status "Installing fish shell..."
                brew install fish
            fi
            
            if ! command -v nvim &> /dev/null; then
                print_status "Installing Neovim..."
                brew install neovim
            fi
            
            if ! command -v starship &> /dev/null; then
                print_status "Installing Starship..."
                brew install starship
            fi
            
            if ! command -v ghostty &> /dev/null; then
                print_status "Installing Ghostty..."
                brew install --cask ghostty
            fi
            ;;
    esac
}

# Clone kickstart.nvim
setup_neovim() {
    local nvim_config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
    
    if [ -d "$nvim_config_dir" ]; then
        print_warning "Neovim config directory already exists at $nvim_config_dir"
        read -p "Do you want to backup and replace it? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Backing up existing Neovim config..."
            mv "$nvim_config_dir" "${nvim_config_dir}.backup.$(date +%Y%m%d_%H%M%S)"
        else
            print_status "Skipping Neovim setup..."
            return
        fi
    fi
    
    print_status "Cloning kickstart.nvim..."
    git clone https://github.com/nvim-lua/kickstart.nvim.git "$nvim_config_dir"
}

# Setup dotfiles with stow
setup_dotfiles() {
    print_status "Setting up dotfiles with stow..."
    
    # Create .config directory if it doesn't exist
    mkdir -p "$HOME/.config"
    
    # Use stow to symlink configurations
    if [ -d ".config" ]; then
        print_status "Symlinking .config files..."
        stow -t "$HOME" .config 2>/dev/null || print_warning "Some .config files may already exist"
    fi
    
    if [ -f "starship.toml" ]; then
        print_status "Symlinking starship.toml..."
        mkdir -p "$HOME/.config"
        ln -sf "$PWD/starship.toml" "$HOME/.config/starship.toml"
    fi
}

# Change default shell to fish
setup_fish_shell() {
    if command -v fish &> /dev/null; then
        local fish_path=$(which fish)
        if ! grep -q "$fish_path" /etc/shells; then
            print_status "Adding fish to /etc/shells..."
            echo "$fish_path" | sudo tee -a /etc/shells
        fi
        
        if [ "$SHELL" != "$fish_path" ]; then
            print_status "Changing default shell to fish..."
            chsh -s "$fish_path"
            print_status "Please log out and log back in for shell change to take effect."
        fi
    fi
}

main() {
    print_status "Starting dotfiles installation..."
    
    detect_os
    install_dependencies
    setup_neovim
    setup_dotfiles
    setup_fish_shell
    
    print_status "Dotfiles installation completed!"
    print_status "Please restart your terminal or log out and log back in for all changes to take effect."
}

# Run main function
main "$@"