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

#git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin main"
alias gpu="git pull origin"
alias gst="git status"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'


# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

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
