export DOTFILES="${DOTFILES:-$HOME/dotfiles}"

# ── PATH ────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
[ -d "/opt/homebrew/bin" ] && export PATH="/opt/homebrew/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL/bin" ] && export PATH="$BUN_INSTALL/bin:$PATH"

# ── History ─────────────────────────────────────────────────────────
HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoredups:ignorespace

# ── Aliases ─────────────────────────────────────────────────────────
command -v eza     >/dev/null 2>&1 && alias ls='eza --icons' ll='eza -lah --icons' lt='eza -T --icons'
command -v bat     >/dev/null 2>&1 && alias cat='bat'
command -v lazygit >/dev/null 2>&1 && alias lg='lazygit'
command -v kubectl >/dev/null 2>&1 && alias k='kubectl'
alias gst="git status" gca="git commit -a -m" gp="git push origin HEAD" gdiff="git diff" gadd="git add"
alias ..='cd ..' ...='cd ../..' ....='cd ../../..'

# ── Starship ────────────────────────────────────────────────────────
command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

# ── Zoxide ──────────────────────────────────────────────────────────
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)" && alias cd='z'

# ── fzf (Ctrl-R history · Ctrl-T file picker · Alt-C cd into dir) ────
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --bash)"                                 # keybindings + completion (fzf ≥0.48)
  export FZF_DEFAULT_OPTS="--height 45% --layout reverse --border --info inline"
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
fi

# mkcd: make a directory (and parents) then jump into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# ── NVM (lazy-loaded) ───────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  _nvm_lazy_load() { unset -f nvm node npm npx; . "$NVM_DIR/nvm.sh"; }
  nvm()  { _nvm_lazy_load; nvm "$@"; }
  node() { _nvm_lazy_load; command node "$@"; }
  npm()  { _nvm_lazy_load; command npm "$@"; }
  npx()  { _nvm_lazy_load; command npx "$@"; }
fi

# ── GPG ─────────────────────────────────────────────────────────────
[ -t 0 ] && export GPG_TTY=$(tty 2>/dev/null)

# ── Fastfetch (skip in IDEs) ────────────────────────────────────────
if [[ $- == *i* ]] && [[ "$TERM_PROGRAM" != "vscode" && "$TERM_PROGRAM" != "Cursor" ]]; then
  clear && fastfetch -c "$DOTFILES/config/fastfetch/config.jsonc" 2>/dev/null || true
fi

# ── Local overrides (machine-specific, never committed) ─────────────
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
