export DOTFILES="${DOTFILES:-$HOME/dotfiles}"

# ── PATH ────────────────────────────────────────────────────────────
typeset -U path PATH                     # auto-dedupe PATH (no repeated entries)
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
[ -d "/opt/homebrew/bin" ] && export PATH="/opt/homebrew/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL/bin" ] && export PATH="$BUN_INSTALL/bin:$PATH"

# ── History ─────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS    # drop older duplicate when a command repeats
setopt HIST_IGNORE_SPACE       # don't record commands prefixed with a space
setopt HIST_REDUCE_BLANKS      # strip superfluous whitespace before saving
setopt HIST_VERIFY             # expand !! / history into the line, don't run blind
setopt SHARE_HISTORY           # share history live across all open shells
setopt EXTENDED_HISTORY        # store timestamps + duration per command

# ── Zsh options ─────────────────────────────────────────────────────
setopt AUTO_CD                 # type a dir name to cd into it
setopt NO_CASE_GLOB            # case-insensitive globbing
setopt CORRECT                 # offer correction for mistyped commands
setopt INTERACTIVE_COMMENTS    # allow # comments in the interactive shell

# ── Completions (cached) ────────────────────────────────────────────
autoload -Uz compinit
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"
[[ ! -f "$ZSH_COMPDUMP" || -n $(find "$ZSH_COMPDUMP" -mmin +1440 2>/dev/null) ]] \
    && compinit -d "$ZSH_COMPDUMP" || compinit -C -d "$ZSH_COMPDUMP"

# ── Starship ────────────────────────────────────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ── Zoxide ──────────────────────────────────────────────────────────
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)" && alias cd='z'

# ── fzf (Ctrl-R history · Ctrl-T file picker · Alt-C cd into dir) ────
if command -v fzf &>/dev/null; then
  source <(fzf --zsh)                                  # keybindings + completion (fzf ≥0.48)
  export FZF_DEFAULT_OPTS="--height 45% --layout reverse --border --info inline"
  if command -v fd &>/dev/null; then                   # use fd: faster, respects .gitignore
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
fi

# ── Zsh plugins ─────────────────────────────────────────────────────
_src() { for f in "$@"; do [[ -f "$f" ]] && source "$f" && return; done; }
_brew="${HOMEBREW_PREFIX:-/opt/homebrew}"
_src "$_brew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
     /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
_src "$_brew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
     /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
unfunction _src 2>/dev/null; unset _brew

# ── Bun completions ─────────────────────────────────────────────────
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

# ── NVM (lazy-loaded) ───────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  _nvm_lazy_load() { unfunction nvm node npm npx 2>/dev/null; . "$NVM_DIR/nvm.sh"; }
  nvm()  { _nvm_lazy_load; nvm "$@"; }
  node() { _nvm_lazy_load; command node "$@"; }
  npm()  { _nvm_lazy_load; command npm "$@"; }
  npx()  { _nvm_lazy_load; command npx "$@"; }
fi

# ── GPG ─────────────────────────────────────────────────────────────
[[ -t 0 ]] && export GPG_TTY=$(tty 2>/dev/null)

# ── Aliases ─────────────────────────────────────────────────────────
command -v eza     &>/dev/null && alias ls='eza --icons --group-directories-first' \
                                        ll='eza -lah --icons --git --group-directories-first' \
                                        lt='eza -T --icons --level=2'
command -v bat     &>/dev/null && alias cat='bat'
command -v lazygit &>/dev/null && alias lg='lazygit'
command -v kubectl &>/dev/null && alias k='kubectl'
alias gst="git status" gca="git commit -a -m" gp="git push origin HEAD" gdiff="git diff" gadd="git add"
alias gco="git checkout" gl="git graph"          # gl → pretty all-branch log (alias in .gitconfig)
alias ..='cd ..' ...='cd ../..' ....='cd ../../..'

# mkcd: make a directory (and parents) then jump into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# ── Sketchybar todo ─────────────────────────────────────────────────
[ -f "$DOTFILES/config/sketchybar/todo.command" ] && \
    todo() { "$DOTFILES/config/sketchybar/todo.command" "$@"; }

# ── Fastfetch (skip in IDEs) ────────────────────────────────────────
if [[ -o interactive ]] && [[ "$TERM_PROGRAM" != "vscode" && "$TERM_PROGRAM" != "Cursor" ]]; then
  clear && fastfetch -c "$DOTFILES/config/fastfetch/config.jsonc" 2>/dev/null || true
fi

# ── Local overrides (machine-specific, never committed) ─────────────
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
