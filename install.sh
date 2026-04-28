#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 1. Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     OS_TYPE=Linux;;
    Darwin*)    OS_TYPE=Mac;;
    CYGWIN*|MINGW*|MSYS*) OS_TYPE=Windows;;
    *)          OS_TYPE="UNKNOWN:${OS}"
esac

log_info "Detected OS: $OS_TYPE"

if [ "$OS_TYPE" = "UNKNOWN:${OS}" ]; then
    log_error "Unsupported OS. Exiting."
    exit 1
fi

# 2. Package Manager Setup & Core Dependencies
install_packages() {
    log_info "Installing core packages..."
    if [ "$OS_TYPE" = "Mac" ]; then
        if ! command -v brew &> /dev/null; then
            log_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        brew install curl wget git zsh tmux eza starship zoxide fzf unzip fastfetch
    elif [ "$OS_TYPE" = "Linux" ]; then
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y curl wget git zsh tmux unzip fzf default-jre
            
            # fastfetch, eza, starship, zoxide might not be in older apt repos or require special steps
            if ! command -v eza &> /dev/null; then
                sudo mkdir -p /etc/apt/keyrings
                wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg || true
                echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://apt.fury.io/eza/ /" | sudo tee /etc/apt/sources.list.d/gierens.list || true
                sudo apt update || true
                sudo apt install -y eza || true
            fi
            
            if ! command -v fastfetch &> /dev/null; then
                sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch || true
                sudo apt update || true
                sudo apt install -y fastfetch || true
            fi

            curl -sS https://starship.rs/install.sh | sh -s -- -y
            curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        elif command -v pacman &> /dev/null; then
            sudo pacman -Syu --noconfirm curl wget git zsh tmux eza starship zoxide fzf unzip fastfetch
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y curl wget git zsh tmux eza starship zoxide fzf unzip fastfetch
        else
            log_warn "Could not detect package manager (apt/pacman/dnf). Please install curl, wget, git, zsh, tmux, eza, starship, zoxide, fastfetch manually."
        fi
    fi
}

install_packages

# 3. Dev Tools Setup
setup_dev_tools() {
    log_info "Setting up Dev Tools..."
    
    # Node (NVM)
    if [ ! -d "$HOME/.nvm" ]; then
        log_info "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    fi

    # Bun
    if ! command -v bun &> /dev/null; then
        log_info "Installing Bun..."
        curl -fsSL https://bun.sh/install | bash
    fi

    # Rust
    if ! command -v cargo &> /dev/null; then
        log_info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi
}

setup_dev_tools

# 4. macOS Specifics
if [ "$OS_TYPE" = "Mac" ]; then
    log_info "Installing macOS specific tools (aerospace, sketchybar)..."
    brew tap nikitabobko/tap
    brew install --cask aerospace || true
    
    brew tap FelixKratz/formulae
    brew install sketchybar || true
    
    # Start sketchybar service
    brew services start sketchybar || true
fi

# 5. Symlinking configs
symlink_config() {
    local src="$1"
    local dest="$2"

    # Create parent directory for destination if it doesn't exist
    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ ! -d "$BACKUP_DIR" ]; then
            mkdir -p "$BACKUP_DIR"
            log_info "Created backup directory at $BACKUP_DIR"
        fi
        
        # If it's a directory, move it gracefully
        if [ -d "$dest" ] && [ ! -L "$dest" ]; then
            mv "$dest" "$BACKUP_DIR/$(basename "$dest")_dir_backup"
            log_warn "Backed up existing directory $dest to $BACKUP_DIR"
        else
            mv "$dest" "$BACKUP_DIR/"
            log_warn "Backed up existing $dest to $BACKUP_DIR"
        fi
    fi

    ln -s "$src" "$dest"
    log_success "Symlinked $src -> $dest"
}

log_info "Symlinking configurations..."

symlink_config "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
symlink_config "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
symlink_config "$DOTFILES_DIR/wezterm" "$HOME/.config/wezterm"
symlink_config "$DOTFILES_DIR/fastfetch" "$HOME/.config/fastfetch"
symlink_config "$DOTFILES_DIR/gh" "$HOME/.config/gh"

if [ "$OS_TYPE" = "Mac" ]; then
    symlink_config "$DOTFILES_DIR/aerospace" "$HOME/.config/aerospace"
    symlink_config "$DOTFILES_DIR/sketchybar" "$HOME/.config/sketchybar"
fi

# 6. Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    log_info "Installing Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    log_info "TPM already installed."
fi

# 7. Default Shell
if [ "$SHELL" != "$(which zsh)" ] && [ -x "$(which zsh)" ]; then
    log_info "Changing default shell to zsh. You may be prompted for your password."
    chsh -s "$(which zsh)" || log_warn "Could not change default shell. Please run: chsh -s $(which zsh)"
else
    log_info "zsh is already the default shell."
fi

log_success "Dotfiles installation complete! Please restart your terminal."
