eval "$(starship init zsh)"

eval "$(zoxide init zsh)"
alias cd="z"

export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
