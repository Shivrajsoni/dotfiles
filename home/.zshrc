export DOTFILES="${DOTFILES:-$HOME/dotfiles}"
typeset -U path                          # keep PATH free of duplicates
source "$DOTFILES/config/shell/common.sh"

# ── History ─────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS HIST_VERIFY
setopt SHARE_HISTORY EXTENDED_HISTORY    # live-shared across shells, with timestamps

# ── Options ─────────────────────────────────────────────────────────
setopt AUTO_CD NO_CASE_GLOB INTERACTIVE_COMMENTS

# ── Completion ──────────────────────────────────────────────────────
# Full (secure) rebuild once a day; otherwise trust the cached dump (-C).
autoload -Uz compinit
() {
  setopt localoptions extendedglob
  local dump="${ZDOTDIR:-$HOME}/.zcompdump"
  if [[ -n $dump(#qN.mh-24) ]]; then compinit -C -d "$dump"; else compinit -d "$dump"; fi
}
[[ -s $BUN_INSTALL/_bun ]] && source "$BUN_INSTALL/_bun"

# ── Integrations ────────────────────────────────────────────────────
has fzf       && source <(fzf --zsh)     # Ctrl-R history · Ctrl-T files · Alt-C cd
has starship  && eval "$(starship init zsh)"
# Skipped in Claude Code: its shell snapshot copies the `cd` override but not
# zoxide's chpwd hook, so zoxide's doctor warns on every command.
has zoxide && [[ -z $CLAUDECODE ]] && eval "$(zoxide init zsh --cmd cd)"

# Lazy conda: `conda init` costs ~100ms per shell.
if [[ -x $HOME/miniconda3/bin/conda ]]; then
  conda() { unfunction conda; eval "$("$HOME/miniconda3/bin/conda" shell.zsh hook)"; conda "$@"; }
fi

# ── Plugins (Homebrew or Linux system path; highlighting must load last) ──
_plugin() {
  local dir
  for dir in /opt/homebrew/share /usr/share; do
    [[ -f $dir/$1/$1.zsh ]] && { source "$dir/$1/$1.zsh"; return; }
  done
}
_plugin zsh-autosuggestions
_plugin zsh-syntax-highlighting
unfunction _plugin

# ── Greeting (skip inside IDE terminals) ────────────────────────────
if has fastfetch && [[ $TERM_PROGRAM != (vscode|Cursor) ]]; then
  fastfetch -c "$DOTFILES/config/fastfetch/config.jsonc" 2>/dev/null
fi

# ── Machine-specific overrides (never committed) ────────────────────
[[ -f $HOME/.zshrc.local ]] && source "$HOME/.zshrc.local"
