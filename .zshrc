eval "$(starship init zsh)"

eval "$(zoxide init zsh)"
alias cd="z"

export NVM_DIR=~/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

#making gcc by default
export PATH="/opt/homebrew/bin:$PATH"
alias gcc='gcc-14'
alias g++='g++-14'
# Replace ls with eza
alias ls='eza --icons '
alias ll='eza -lah --icons'  # Long format, human-readable, hidden files
alias lt='eza -T --icons'  # Tree view

alias lg='eza -l --git --icons'  # Show git status
#git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin main"
alias gpu="git pull origin"
alias gst="git status"



#Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# pnpm
export PNPM_HOME="/Users/shivraj/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/shivraj/.bun/_bun" ] && source "/Users/shivraj/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
