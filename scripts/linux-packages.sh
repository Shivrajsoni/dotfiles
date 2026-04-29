#!/usr/bin/env bash
# Linux Package Installer
# Mirrors the Brewfile for Linux distros (apt/pacman/dnf)
# Handles package name differences across distros

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[linux]${NC} $1"; }
log_done() { echo -e "${GREEN}[linux]${NC} $1"; }
log_err()  { echo -e "${RED}[linux]${NC} $1"; }

if [ "$(uname -s)" != "Linux" ]; then
    echo "Not Linux — skipping."
    exit 0
fi

# ── Detect package manager ──────────────────────────────────────────
if command -v apt &>/dev/null; then
    PKG="apt"
    INSTALL="sudo apt install -y"
    UPDATE="sudo apt update"
elif command -v pacman &>/dev/null; then
    PKG="pacman"
    INSTALL="sudo pacman -S --noconfirm"
    UPDATE="sudo pacman -Syu --noconfirm"
elif command -v dnf &>/dev/null; then
    PKG="dnf"
    INSTALL="sudo dnf install -y"
    UPDATE="sudo dnf check-update || true"
else
    log_err "No supported package manager found (need apt, pacman, or dnf)"
    exit 1
fi

log_info "Detected package manager: $PKG"
$UPDATE

# ── Core packages (same name across distros) ────────────────────────
COMMON="zsh tmux git curl wget unzip jq htop tree fzf ripgrep"

log_info "Installing core packages..."
$INSTALL $COMMON

# ── Packages with different names per distro ─────────────────────────
log_info "Installing distro-specific packages..."

case "$PKG" in
    apt)
        # bat is 'batcat' on Debian/Ubuntu, fd is 'fd-find'
        $INSTALL bat fd-find
        # Create symlinks for consistent names
        [ ! -L /usr/local/bin/bat ] && sudo ln -sf "$(which batcat)" /usr/local/bin/bat 2>/dev/null || true
        [ ! -L /usr/local/bin/fd ]  && sudo ln -sf "$(which fdfind)" /usr/local/bin/fd 2>/dev/null || true
        # eza: install from cargo if not in apt
        if ! command -v eza &>/dev/null; then
            if command -v cargo &>/dev/null; then
                cargo install eza
            else
                log_info "eza requires cargo — will be available after dev-toolchain.sh runs"
            fi
        fi
        ;;
    pacman)
        $INSTALL bat fd eza
        ;;
    dnf)
        $INSTALL bat fd-find eza
        ;;
esac

# ── Tools installed via universal scripts (not in repos) ─────────────
log_info "Installing tools via universal installers..."

# Starship
if ! command -v starship &>/dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Zoxide
if ! command -v zoxide &>/dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# Fastfetch
if ! command -v fastfetch &>/dev/null; then
    case "$PKG" in
        apt)    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch 2>/dev/null && sudo apt update && $INSTALL fastfetch || log_info "Install fastfetch manually: https://github.com/fastfetch-cli/fastfetch" ;;
        pacman) $INSTALL fastfetch ;;
        dnf)    $INSTALL fastfetch ;;
    esac
fi

# Delta (git diff pager)
if ! command -v delta &>/dev/null; then
    if command -v cargo &>/dev/null; then
        cargo install git-delta
    else
        log_info "delta requires cargo — will be available after dev-toolchain.sh runs"
    fi
fi

# Yazi (terminal file manager)
if ! command -v yazi &>/dev/null; then
    if command -v cargo &>/dev/null; then
        cargo install --locked yazi-fm yazi-cli
    else
        log_info "yazi requires cargo — will be available after dev-toolchain.sh runs"
    fi
fi

echo ""
log_done "Linux packages installed successfully!"
