#!/usr/bin/env bash
# Linux equivalent of the Brewfile (apt / pacman / dnf).
set -e
source "$(dirname "$0")/lib.sh"

[ "$OS" = linux ] || { warn "Not Linux"; exit 0; }

if has apt; then
  PM=apt;    INSTALL="$SUDO apt install -y";            $SUDO apt update
elif has pacman; then
  PM=pacman; INSTALL="$SUDO pacman -S --noconfirm --needed"; $SUDO pacman -Sy
elif has dnf; then
  PM=dnf;    INSTALL="$SUDO dnf install -y"
else
  err "Need apt, pacman, or dnf"; exit 1
fi
info "Package manager: $PM"

$INSTALL zsh tmux git curl wget unzip jq htop tree fzf ripgrep gh tldr zsh-autosuggestions zsh-syntax-highlighting

# Names differ per distro
case "$PM" in
  apt)    $INSTALL bat fd-find
          # Debian/Ubuntu ship these as batcat / fdfind
          $SUDO ln -sf "$(command -v batcat)" /usr/local/bin/bat
          $SUDO ln -sf "$(command -v fdfind)" /usr/local/bin/fd ;;
  pacman) $INSTALL bat fd eza fastfetch lazygit ;;
  dnf)    $INSTALL bat fd-find eza fastfetch lazygit ;;
esac

# Not in distro repos → official installers / cargo (cargo comes from dev-toolchain.sh)
has starship || curl -sS https://starship.rs/install.sh | sh -s -- -y
has zoxide   || curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

for crate in eza:eza delta:git-delta yazi:yazi-fm; do
  has "${crate%%:*}" && continue
  if has cargo; then cargo install --locked "${crate#*:}"
  else warn "${crate%%:*} needs cargo; re-run after dev-toolchain.sh"; fi
done

ok "Linux packages installed"
