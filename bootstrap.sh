#!/usr/bin/env bash
# bootstrap.sh — One-command dotfiles setup
# Usage: bash bootstrap.sh [--dry-run]

set -e

# ── Auto-detect repo location ──────────────────────────────────────
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false
[ "$1" = "--dry-run" ] && DRY_RUN=true

# ── Logging ─────────────────────────────────────────────────────────
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}[info]${NC} $1"; }
log_success() { echo -e "${GREEN}[done]${NC} $1"; }
log_error()   { echo -e "${RED}[error]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[skip]${NC} $1"; }

run() {
    if $DRY_RUN; then
        echo -e "${YELLOW}[dry-run]${NC} $*"
    else
        "$@"
    fi
}

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║       Dotfiles Bootstrap             ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
log_info "Dotfiles directory: $DOTFILES_DIR"
$DRY_RUN && log_warn "Dry-run mode — no changes will be made"

# ── 1. Detect OS ────────────────────────────────────────────────────
OS_TYPE="$(uname -s)"
case "$OS_TYPE" in
    Darwin*) OS_TYPE="Mac"   ;;
    Linux*)  OS_TYPE="Linux" ;;
    *)       log_error "Unsupported OS: $OS_TYPE"; exit 1 ;;
esac
export OS_TYPE
log_info "Detected OS: $OS_TYPE"

# ── 2. Install system packages ──────────────────────────────────────
log_info "Installing system packages..."

if [ "$OS_TYPE" = "Mac" ]; then
    # Install Homebrew if missing
    if ! command -v brew &>/dev/null; then
        log_info "Installing Homebrew..."
        run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    # Install all packages from Brewfile
    log_info "Running brew bundle..."
    run brew bundle --file="$DOTFILES_DIR/Brewfile" --no-lock || true
    # Start sketchybar service
    run brew services start sketchybar 2>/dev/null || true
elif [ "$OS_TYPE" = "Linux" ]; then
    run bash "$DOTFILES_DIR/scripts/linux-packages.sh"
fi

log_success "System packages installed"

# ── 3. Dev toolchain (NVM, Bun, UV, Rust, C++) ─────────────────────
log_info "Setting up dev toolchain..."
run bash "$DOTFILES_DIR/scripts/dev-toolchain.sh"
log_success "Dev toolchain ready"

# ── 4. macOS defaults (Mac only) ───────────────────────────────────
if [ "$OS_TYPE" = "Mac" ]; then
    log_info "Applying macOS defaults..."
    run bash "$DOTFILES_DIR/scripts/macos-defaults.sh"
fi

# ── 5. Symlink configurations ──────────────────────────────────────
log_info "Symlinking configurations..."

# Format: "source_relative_path:destination_absolute_path"
SYMLINKS=(
    ".zshrc:$HOME/.zshrc"
    ".bashrc:$HOME/.bashrc"
    ".tmux.conf:$HOME/.tmux.conf"
    "starship.toml:$HOME/.config/starship.toml"
    "wezterm:$HOME/.config/wezterm"
    "fastfetch:$HOME/.config/fastfetch"
    "git/.gitconfig:$HOME/.gitconfig"
)

# macOS-only configs
if [ "$OS_TYPE" = "Mac" ]; then
    SYMLINKS+=(
        "aerospace:$HOME/.config/aerospace"
        "sketchybar:$HOME/.config/sketchybar"
    )
fi

for entry in "${SYMLINKS[@]}"; do
    src="$DOTFILES_DIR/${entry%%:*}"
    dest="${entry#*:}"

    # Ensure parent directory exists
    run mkdir -p "$(dirname "$dest")"

    # Backup existing file/directory if it's not already our symlink
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        # Skip if already pointing to our dotfiles
        if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
            log_warn "Already linked: ${entry%%:*}"
            continue
        fi
        # Backup
        if [ ! -d "$BACKUP_DIR" ]; then
            run mkdir -p "$BACKUP_DIR"
            log_info "Backing up existing configs to $BACKUP_DIR"
        fi
        run mv "$dest" "$BACKUP_DIR/"
    fi

    run ln -s "$src" "$dest"
    log_success "Linked ${entry%%:*} → $dest"
done

# ── 6. Tmux Plugin Manager ─────────────────────────────────────────
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    log_info "Installing Tmux Plugin Manager..."
    run git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    log_success "TPM installed"
else
    log_warn "TPM already installed"
fi

# ── 7. Set default shell to zsh ─────────────────────────────────────
ZSH_PATH="$(which zsh 2>/dev/null)"
if [ -n "$ZSH_PATH" ] && [ "$SHELL" != "$ZSH_PATH" ]; then
    log_info "Setting default shell to zsh..."
    SUDO=""
    [ "$(id -u)" -ne 0 ] && SUDO="sudo"
    # Add zsh to /etc/shells if missing
    if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
        run $SUDO sh -c "echo '$ZSH_PATH' >> /etc/shells"
    fi
    run chsh -s "$ZSH_PATH" || log_error "Failed to change shell. Run: chsh -s $ZSH_PATH"
else
    log_warn "Already using zsh"
fi

echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║       Setup Complete!                ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
log_success "Restart your terminal to enjoy."
log_info "Run 'prefix + I' inside tmux to install tmux plugins."
