# Bash config for Linux servers; zsh (home/.zshrc) is the primary shell.
export DOTFILES="${DOTFILES:-$HOME/dotfiles}"
source "$DOTFILES/config/shell/common.sh"

HISTSIZE=50000
HISTFILESIZE=50000
HISTCONTROL=ignoredups:ignorespace

has starship && eval "$(starship init bash)"
has fzf      && eval "$(fzf --bash)"
has zoxide   && eval "$(zoxide init bash --cmd cd)"

if has fastfetch && [[ $- == *i* && $TERM_PROGRAM != vscode && $TERM_PROGRAM != Cursor ]]; then
  fastfetch -c "$DOTFILES/config/fastfetch/config.jsonc" 2>/dev/null
fi

[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
