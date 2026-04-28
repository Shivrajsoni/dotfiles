#!/usr/bin/env bash

set -e

# --- Configuration ---
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Files to symlink (Source:Destination)
SYMLINKS=(
    ".zshrc:$HOME/.zshrc"
    ".tmux.conf:$HOME/.tmux.conf"
    "wezterm:$HOME/.config/wezterm"
    "fastfetch:$HOME/.config/fastfetch"
)

# --- Logging ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# --- 1. Detect OS ---
OS="$(uname -s)"
case "${OS}" in
    Linux*)     OS_TYPE=Linux;;
    Darwin*)    OS_TYPE=Mac;;
    *)          log_error "Unsupported OS. Exiting."; exit 1;;
esac

log_info "Detected OS: $OS_TYPE"

# --- 2. Install Core System Packages ---
log_info "Installing core system packages..."
if [ "$OS_TYPE" = "Mac" ]; then
    if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    brew install curl wget git zsh tmux unzip eza yazi bat
    
    # macOS specifics
    brew tap nikitabobko/tap
    brew install --cask aerospace || true
    brew tap FelixKratz/formulae
    brew install sketchybar || true
    brew services start sketchybar || true

    SYMLINKS+=("aerospace:$HOME/.config/aerospace")
    SYMLINKS+=("sketchybar:$HOME/.config/sketchybar")
elif [ "$OS_TYPE" = "Linux" ]; then
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y curl wget git zsh tmux unzip
    elif command -v pacman &> /dev/null; then
        sudo pacman -Syu --noconfirm curl wget git zsh tmux unzip
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y curl wget git zsh tmux unzip
    else
        log_error "Could not detect package manager. Install curl, wget, git, zsh, tmux manually."
    fi
fi

# --- 3. Install Universal Modern Tools ---
log_info "Installing modern terminal tools via universal scripts..."

# Starship
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Zoxide
if ! command -v zoxide &> /dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# NVM
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Bun
if ! command -v bun &> /dev/null; then
    curl -fsSL https://bun.sh/install | bash
fi

# Rust
if ! command -v cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# --- 4. Safely Symlink Configurations ---
log_info "Symlinking configurations..."
for entry in "${SYMLINKS[@]}"; do
    src="$DOTFILES_DIR/${entry%%:*}"
    dest="${entry#*:}"

    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ ! -d "$BACKUP_DIR" ]; then
            mkdir -p "$BACKUP_DIR"
            log_info "Created backup directory at $BACKUP_DIR"
        fi
        mv "$dest" "$BACKUP_DIR/"
    fi

    ln -s "$src" "$dest"
    log_success "Symlinked ${entry%%:*} -> $dest"
done

# --- 5. Tmux Plugin Manager ---
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    log_info "Installing Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# --- 6. Set Default Shell ---
if [ "$SHELL" != "$(which zsh)" ] && [ -x "$(which zsh)" ]; then
    log_info "Changing default shell to zsh..."
    chsh -s "$(which zsh)" || log_error "Failed to change shell. Run: chsh -s $(which zsh)"
fi

log_success "Installation complete! Restart your terminal to enjoy."
