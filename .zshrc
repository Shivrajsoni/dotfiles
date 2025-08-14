eval "$(starship init zsh)"

eval "$(zoxide init zsh)"

eval "$(rbenv init - zsh)"
alias cd='z'

#making yarn bin path add 
export PATH="/Users/shivraj/.yarn/bin:$(yarn global bin):$PATH"

#making gcc by default
export PATH="/opt/homebrew/bin:$PATH"

export PATH="/$HOME/.cargo/bin:$PATH"



# Replace ls with eza
alias ls='eza --icons '
alias ll='eza -lah --icons'  # Long format, human-readable, hidden files
alias lt='eza -T --icons'  # Tree view


alias lg='eza -l --git --icons'  # Show git status
#git
alias gst="git status"
alias gm="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

alias k='kubectl'



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


export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


#!bin/bash
clear
fastfetch
