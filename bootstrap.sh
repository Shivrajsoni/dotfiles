#!/usr/bin/env bash
# One-command setup. Usage: bash bootstrap.sh [--dry-run] [--link-only]
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$DOTFILES_DIR/scripts/lib.sh"

BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false
LINK_ONLY=false
for arg in "$@"; do
  case "$arg" in
    --dry-run)   DRY_RUN=true ;;
    --link-only) LINK_ONLY=true ;;
    *) err "Unknown flag: $arg"; exit 1 ;;
  esac
done

run() { if $DRY_RUN; then echo "[dry-run] $*"; else "$@"; fi; }

info "Dotfiles: $DOTFILES_DIR ($OS)"

# ── 1. Packages, toolchain, system defaults ─────────────────────────
if ! $LINK_ONLY; then
  if [ "$OS" = mac ]; then
    if ! has brew; then
      run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    run brew bundle --file="$DOTFILES_DIR/Brewfile"
    run bash "$DOTFILES_DIR/scripts/macos-defaults.sh"
  else
    run bash "$DOTFILES_DIR/scripts/linux-packages.sh"
  fi
  run bash "$DOTFILES_DIR/scripts/dev-toolchain.sh"
fi

# ── 2. Symlinks (existing files are moved to $BACKUP_DIR) ───────────
LINKS=(
  "home/.zshrc:$HOME/.zshrc"
  "home/.bashrc:$HOME/.bashrc"
  "home/.tmux.conf:$HOME/.tmux.conf"
  "git/.gitconfig:$HOME/.gitconfig"
  "config/starship/starship.toml:$HOME/.config/starship.toml"
  "config/wezterm:$HOME/.config/wezterm"
  "config/fastfetch:$HOME/.config/fastfetch"
)
[ "$OS" = mac ] && LINKS+=(
  "config/aerospace:$HOME/.config/aerospace"
)

for entry in "${LINKS[@]}"; do
  src="$DOTFILES_DIR/${entry%%:*}"
  dest="${entry#*:}"

  if [ "$(readlink "$dest" 2>/dev/null)" = "$src" ]; then
    warn "Already linked: ${entry%%:*}"
    continue
  fi
  run mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    run mkdir -p "$BACKUP_DIR"
    run mv "$dest" "$BACKUP_DIR/"
    info "Backed up $dest"
  fi
  run ln -s "$src" "$dest"
  ok "Linked ${entry%%:*}"
done

# ── 3. DOTFILES env var, tmux plugin manager, services ──────────────
grep -qs "DOTFILES=" "$HOME/.zshenv" || run sh -c "echo 'export DOTFILES=\"$DOTFILES_DIR\"' >> \"$HOME/.zshenv\""

[ -d "$HOME/.tmux/plugins/tpm" ] || run git clone -q https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

# ── 4. Default shell → zsh ──────────────────────────────────────────
ZSH_PATH="$(command -v zsh || true)"
if [ -n "$ZSH_PATH" ] && [ "$SHELL" != "$ZSH_PATH" ]; then
  grep -qs "^$ZSH_PATH$" /etc/shells || run sh -c "echo '$ZSH_PATH' | $SUDO tee -a /etc/shells >/dev/null"
  run chsh -s "$ZSH_PATH" || err "chsh failed. Run: chsh -s $ZSH_PATH"
fi

ok "Setup complete. Restart your terminal, then press prefix + I in tmux to install plugins."
