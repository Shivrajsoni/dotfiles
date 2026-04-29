# ── PATH ────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL/bin" ] && export PATH="$BUN_INSTALL/bin:$PATH"

# ── Aliases ─────────────────────────────────────────────────────────
command -v eza >/dev/null 2>&1 && alias ls='eza --icons' && alias ll='eza -lah --icons' && alias lt='eza -T --icons'
command -v bat >/dev/null 2>&1 && alias cat='bat'
alias gst="git status" gca="git commit -a -m" gp="git push origin HEAD" gdiff="git diff" gadd="git add"
alias ..='cd ..' ...='cd ../..' ....='cd ../../..'
command -v kubectl >/dev/null 2>&1 && alias k='kubectl'

# ── Starship ────────────────────────────────────────────────────────
export STARSHIP_CONFIG="${DOTFILES:-$HOME/dotfiles}/starship.toml"
command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

# ── Zoxide ──────────────────────────────────────────────────────────
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)" && alias cd='z'

# ── NVM (lazy-loaded) ──────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  nvm()  { unset -f nvm node npm npx; . "$NVM_DIR/nvm.sh"; nvm "$@"; }
  node() { unset -f nvm node npm npx; . "$NVM_DIR/nvm.sh"; command node "$@"; }
  npm()  { unset -f nvm node npm npx; . "$NVM_DIR/nvm.sh"; command npm "$@"; }
  npx()  { unset -f nvm node npm npx; . "$NVM_DIR/nvm.sh"; command npx "$@"; }
fi

# ── GPG ─────────────────────────────────────────────────────────────
[ -t 0 ] && export GPG_TTY=$(tty 2>/dev/null)

# ── Fastfetch (skip in IDEs) ───────────────────────────────────────
if [[ $- == *i* ]] && [[ "$TERM_PROGRAM" != "vscode" && "$TERM_PROGRAM" != "Cursor" ]]; then
  clear && fastfetch -c "${DOTFILES:-$HOME/dotfiles}/fastfetch/config.jsonc" 2>/dev/null || true
fi
