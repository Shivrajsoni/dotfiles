# ── Starship prompt ─────────────────────────────────────────────────
export STARSHIP_CONFIG="${DOTFILES:-$HOME/dotfiles}/starship.toml"
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ── Zoxide (smart cd) ──────────────────────────────────────────────
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# ── PATH (guard duplicates on nested shells) ────────────────────────
_prepend_path() { [[ ":$PATH:" != *":$1:"* ]] && [ -d "$1" ] && export PATH="$1:$PATH"; }
_prepend_path "$HOME/.local/bin"
_prepend_path "$HOME/.cargo/bin"
_prepend_path "/opt/homebrew/bin"
unfunction _prepend_path

# ── Aliases: File utilities (guarded) ───────────────────────────────
command -v eza &>/dev/null && alias ls='eza --icons' && alias ll='eza -lah --icons' && alias lt='eza -T --icons' && alias lg='eza -l --git --icons'
command -v bat &>/dev/null && alias cat='bat'

# ── Aliases: Git ────────────────────────────────────────────────────
alias gst="git status"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gdiff="git diff"
alias gadd='git add'

# ── Aliases: Navigation ────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

command -v kubectl &>/dev/null && alias k='kubectl'

# ── Bun ─────────────────────────────────────────────────────────────
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL/bin" ] && [[ ":$PATH:" != *":$BUN_INSTALL/bin:"* ]] && export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ── NVM (lazy-loaded) ──────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  _nvm_lazy_load() {
    unfunction nvm node npm npx 2>/dev/null
    . "$NVM_DIR/nvm.sh"
  }
  nvm()  { _nvm_lazy_load; nvm "$@"; }
  node() { _nvm_lazy_load; command node "$@"; }
  npm()  { _nvm_lazy_load; command npm "$@"; }
  npx()  { _nvm_lazy_load; command npx "$@"; }
fi

# ── GPG ─────────────────────────────────────────────────────────────
[[ -t 0 ]] && export GPG_TTY=$(tty 2>/dev/null)

# ── Fastfetch (terminal greeting — skip in IDEs) ───────────────────
if [[ -o interactive ]] && [[ "$TERM_PROGRAM" != "vscode" && "$TERM_PROGRAM" != "Cursor" ]]; then
  clear && fastfetch -c "${DOTFILES:-$HOME/dotfiles}/fastfetch/config.jsonc" 2>/dev/null || true
fi

# ── Completions (cached — regenerate once per day) ──────────────────
fpath=(~/.zsh/completions $fpath)
autoload -Uz compinit
if [[ -z "$ZSH_COMPDUMP" ]]; then
  ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
fi
# Only regenerate if dump is older than 24h
if [[ ! -f "$ZSH_COMPDUMP" ]] || [[ $(find "$ZSH_COMPDUMP" -mtime +1 2>/dev/null) ]]; then
  compinit -d "$ZSH_COMPDUMP"
else
  compinit -C -d "$ZSH_COMPDUMP"
fi

# ── Tmux sessionx ──────────────────────────────────────────────────
export SESH_FILE_PATH="$HOME/.local/share/sesh/_sesh"

# ── Sketchybar todo ────────────────────────────────────────────────
todo() { "${DOTFILES:-$HOME/dotfiles}/sketchybar/todo.command" "$@"; }
