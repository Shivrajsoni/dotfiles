# Shared by home/.zshrc and home/.bashrc (bash + zsh compatible).
# Sourced via $DOTFILES, so it needs no symlink.

has() { command -v "$1" >/dev/null 2>&1; }

# ── PATH ────────────────────────────────────────────────────────────
export BUN_INSTALL="$HOME/.bun"
export PATH="/opt/homebrew/bin:$HOME/.local/bin:$HOME/.cargo/bin:$BUN_INSTALL/bin:$PATH"

# ── Environment ─────────────────────────────────────────────────────
export GPG_TTY="${TTY:-$(tty 2>/dev/null)}"
export FZF_DEFAULT_OPTS="--height 45% --layout reverse --border --info inline"
if has fd; then # faster than find, respects .gitignore
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# ── Aliases ─────────────────────────────────────────────────────────
if has eza; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lah --icons --git --group-directories-first'
  alias lt='eza -T --icons --level=2'
fi
has bat     && alias cat='bat'
has lazygit && alias lg='lazygit'

alias gst='git status'
alias gca='git commit -a -m'
alias gp='git push origin HEAD'
alias gl='git graph' # alias defined in git/.gitconfig

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

mkcd() { mkdir -p -- "$1" && cd -- "$1"; }

# ── NVM (lazy: sourcing nvm.sh costs ~300ms per shell) ──────────────
# Each stub removes all stubs, loads the real nvm, then re-runs the command.
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  _nvm_load() { unset -f nvm node npm npx _nvm_load; . "$NVM_DIR/nvm.sh"; }
  for _cmd in nvm node npm npx; do
    eval "$_cmd() { _nvm_load; $_cmd \"\$@\"; }"
  done
  unset _cmd
fi
