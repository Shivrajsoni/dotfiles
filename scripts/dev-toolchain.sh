#!/usr/bin/env bash
# Installs NVM + Node LTS, Bun, UV + Python, Rust, and C++ build tools.
set -e
source "$(dirname "$0")/lib.sh"

# ── Node (NVM) ──────────────────────────────────────────────────────
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ ! -d "$NVM_DIR" ]; then
  info "Installing NVM..."
  curl -fsSo- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
. "$NVM_DIR/nvm.sh"
nvm ls --no-colors lts/* >/dev/null 2>&1 || nvm install --lts
nvm alias default 'lts/*' >/dev/null
ok "Node $(node --version)"

# ── Bun ─────────────────────────────────────────────────────────────
if ! has bun; then
  info "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
  export PATH="$HOME/.bun/bin:$PATH"
fi
ok "Bun $(bun --version)"

# ── UV + Python ─────────────────────────────────────────────────────
if ! has uv; then
  info "Installing UV..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
uv python list --only-installed 2>/dev/null | grep -q cpython || uv python install 3.12
ok "UV $(uv --version | awk '{print $2}')"

# ── Rust ────────────────────────────────────────────────────────────
if ! has cargo; then
  info "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  . "$HOME/.cargo/env"
fi
ok "Rust $(rustc --version | awk '{print $2}')"

# ── C++ build tools ─────────────────────────────────────────────────
if [ "$OS" = mac ]; then
  if ! xcode-select -p >/dev/null 2>&1; then
    info "Installing Xcode Command Line Tools..."
    xcode-select --install
    until xcode-select -p >/dev/null 2>&1; do sleep 5; done
  fi
elif has apt; then
  $SUDO apt install -y build-essential cmake
elif has pacman; then
  $SUDO pacman -S --noconfirm --needed base-devel cmake
elif has dnf; then
  $SUDO dnf groupinstall -y "Development Tools"
  $SUDO dnf install -y gcc-c++ cmake
fi
ok "C++ build tools"
