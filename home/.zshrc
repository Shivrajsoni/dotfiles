export DOTFILES="${DOTFILES:-$HOME/dotfiles}"

# ── Helpers ─────────────────────────────────────────────────────────
# has  → true if a command exists (silently). Use: if has fzf; then ...
# load → source the first file in the list that exists, then stop.
has()  { command -v "$1" >/dev/null 2>&1; }
load() {
  for file in "$@"; do
    if [[ -f "$file" ]]; then
      source "$file"
      return
    fi
  done
}

# ── PATH ────────────────────────────────────────────────────────────
typeset -U path PATH                     # auto-dedupe PATH (no repeated entries)
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"

if [[ -d /opt/homebrew/bin ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

export BUN_INSTALL="$HOME/.bun"
if [[ -d "$BUN_INSTALL/bin" ]]; then
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

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
# Rebuild the completion cache only if it's missing or older than a day,
# otherwise load it as-is (-C skips the slow security check) for fast startup.
autoload -Uz compinit
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"

if [[ ! -f "$ZSH_COMPDUMP" ]]; then
  compinit -d "$ZSH_COMPDUMP"                       # no cache yet → full build
elif [[ -n $(find "$ZSH_COMPDUMP" -mmin +1440 2>/dev/null) ]]; then
  compinit -d "$ZSH_COMPDUMP"                       # cache > 24h old → rebuild
else
  compinit -C -d "$ZSH_COMPDUMP"                    # fresh cache → trust it (fast)
fi

# ── Starship (prompt) ───────────────────────────────────────────────
if has starship; then
  eval "$(starship init zsh)"
fi

# ── Zoxide (smart cd) ───────────────────────────────────────────────
if has zoxide; then
  eval "$(zoxide init zsh)"
  alias cd='z'
fi

# ── fzf (Ctrl-R history · Ctrl-T file picker · Alt-C cd into dir) ────
if has fzf; then
  source <(fzf --zsh)                               # keybindings + completion (fzf ≥0.48)
  export FZF_DEFAULT_OPTS="--height 45% --layout reverse --border --info inline"

  if has fd; then                                   # use fd: faster, respects .gitignore
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
fi

# ── Zsh plugins ─────────────────────────────────────────────────────
# Try the Homebrew path first, fall back to the Linux system path.
brew_prefix="${HOMEBREW_PREFIX:-/opt/homebrew}"

load "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
     /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

load "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
     /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

unset brew_prefix

# ── Bun completions ─────────────────────────────────────────────────
if [[ -s "$BUN_INSTALL/_bun" ]]; then
  source "$BUN_INSTALL/_bun"
fi

# ── NVM (lazy-loaded for fast startup) ──────────────────────────────
# NVM is slow to load, so we don't load it at startup. Instead we create
# stub functions for nvm/node/npm/npx. The first time you run any of them,
# the stub loads the real NVM, removes itself, then runs your command.
export NVM_DIR="$HOME/.nvm"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  load_real_nvm() {
    unfunction nvm node npm npx 2>/dev/null   # remove the stubs
    source "$NVM_DIR/nvm.sh"                   # load the real thing
  }
  nvm()  { load_real_nvm; nvm "$@"; }
  node() { load_real_nvm; command node "$@"; }
  npm()  { load_real_nvm; command npm "$@"; }
  npx()  { load_real_nvm; command npx "$@"; }
fi

# ── GPG ─────────────────────────────────────────────────────────────
# Tell GPG which terminal to ask for the passphrase (only in real terminals).
if [[ -t 0 ]]; then
  export GPG_TTY=$(tty 2>/dev/null)
fi

# ── Aliases ─────────────────────────────────────────────────────────
if has eza; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lah --icons --git --group-directories-first'
  alias lt='eza -T --icons --level=2'
fi

if has bat;     then alias cat='bat';   fi
if has lazygit; then alias lg='lazygit'; fi
if has kubectl; then alias k='kubectl';  fi

# Git shortcuts
alias gst="git status"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gdiff="git diff"
alias gadd="git add"
alias gco="git checkout"
alias gl="git graph"             # pretty all-branch log (alias defined in .gitconfig)

# Jump up directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# mkcd: make a directory (and parents) then jump into it
mkcd() {
  mkdir -p "$1"
  cd "$1"
}

# ── Sketchybar todo ─────────────────────────────────────────────────
if [[ -f "$DOTFILES/config/sketchybar/todo.command" ]]; then
  todo() { "$DOTFILES/config/sketchybar/todo.command" "$@"; }
fi

# ── Fastfetch (skip inside IDE terminals) ───────────────────────────
if [[ -o interactive ]] && [[ "$TERM_PROGRAM" != "vscode" && "$TERM_PROGRAM" != "Cursor" ]]; then
  clear
  fastfetch -c "$DOTFILES/config/fastfetch/config.jsonc" 2>/dev/null || true
fi

# ── Local overrides (machine-specific, never committed) ─────────────
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
