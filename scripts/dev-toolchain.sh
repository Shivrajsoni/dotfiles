#!/usr/bin/env bash
# Dev Toolchain Installer
# Installs: NVM + Node LTS, Bun, UV + Python 3, Rust + Cargo, C++ build tools
# Cross-platform: macOS and Linux (apt/pacman/dnf)

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[toolchain]${NC} $1"; }
log_done() { echo -e "${GREEN}[toolchain]${NC} $1"; }

OS_TYPE="${OS_TYPE:-$(uname -s)}"
case "$OS_TYPE" in
    Darwin*) OS_TYPE="Mac" ;;
    Linux*)  OS_TYPE="Linux" ;;
esac

# ── NVM + Node.js LTS ──────────────────────────────────────────────
log_info "Setting up NVM + Node.js..."
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
if ! nvm ls --no-colors 2>/dev/null | grep -q "lts"; then
    nvm install --lts
fi
nvm alias default lts/* 2>/dev/null || true
log_done "NVM + Node.js LTS ready"

# ── Bun ─────────────────────────────────────────────────────────────
log_info "Setting up Bun..."
if ! command -v bun &>/dev/null; then
    curl -fsSL https://bun.sh/install | bash
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi
log_done "Bun $(bun --version 2>/dev/null || echo 'installed') ready"

# ── UV (Python toolchain) ──────────────────────────────────────────
log_info "Setting up UV + Python..."
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi
# Install latest stable Python 3 if none managed by uv
if ! uv python list --only-installed 2>/dev/null | grep -q "cpython"; then
    uv python install 3.12
fi
log_done "UV + Python ready"

# ── Rust + Cargo ────────────────────────────────────────────────────
log_info "Setting up Rust..."
if ! command -v cargo &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
fi
log_done "Rust $(rustc --version 2>/dev/null | awk '{print $2}' || echo 'installed') ready"

# ── C++ Build Tools ─────────────────────────────────────────────────
log_info "Setting up C++ build tools..."
if [ "$OS_TYPE" = "Mac" ]; then
    if ! xcode-select -p &>/dev/null; then
        log_info "Installing Xcode Command Line Tools (clang, make, etc.)..."
        xcode-select --install
        echo "  → Waiting for Xcode CLI tools installation..."
        until xcode-select -p &>/dev/null; do sleep 5; done
    fi
    log_done "C++ build tools (Xcode CLI) ready"
elif [ "$OS_TYPE" = "Linux" ]; then
    if command -v apt &>/dev/null; then
        sudo apt install -y build-essential gcc g++ make cmake
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm base-devel gcc make cmake
    elif command -v dnf &>/dev/null; then
        sudo dnf groupinstall -y "Development Tools"
        sudo dnf install -y gcc-c++ make cmake
    fi
    log_done "C++ build tools ready"
fi

echo ""
log_done "All dev tools installed successfully!"
