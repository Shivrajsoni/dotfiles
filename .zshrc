eval "$(starship init zsh)"

eval "$(zoxide init zsh)"
alias cd="z"

export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Replace ls with eza
alias ls='eza --icons '
alias ll='eza -lah --icons'  # Long format, human-readable, hidden files
alias lt='eza -T --icons'  # Tree view
alias lg='eza -l --git --icons'  # Show git status
