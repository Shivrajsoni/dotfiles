eval "$(starship init zsh)"

eval "$(zoxide init zsh)"

eval "$(rbenv init - zsh)"
alias cd='z'

# Yarn global bin
export PATH="$HOME/.yarn/bin:$(yarn global bin):$PATH"

#making gcc by default
export PATH="/opt/homebrew/bin:$PATH"

export PATH="$HOME/.cargo/bin:$PATH"


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

alias k='kubectl'
#Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

#Shortcuts
alias r40="rustyvibes ~/Developer/Soundpacks\ 2/cherrymx-black-abs -v 40"


# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"

export PATH="$BUN_INSTALL/bin:$PATH"


export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"

# --- Lazy-load NVM (only runs when you use nvm/node/npm/npx) ---
export NVM_DIR="$HOME/.nvm"
_nvm_lazy_load() {
  unfunction nvm node npm npx 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}
nvm()  { _nvm_lazy_load; nvm "$@"; }
node() { _nvm_lazy_load; command node "$@"; }
npm()  { _nvm_lazy_load; command npm "$@"; }
npx()  { _nvm_lazy_load; command npx "$@"; }

# --- Lazy-load Conda (only runs when you use conda) ---
conda() {
  if [[ -z "$_conda_initialized" ]]; then
    __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
      eval "$__conda_setup"
    else
      [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ] && . "/opt/miniconda3/etc/profile.d/conda.sh" || export PATH="/opt/miniconda3/bin:$PATH"
    fi
    unset __conda_setup
    _conda_initialized=1
  fi
  command conda "$@"
}


# Show fastfetch only in interactive shells (config: random wallpaper logo from ~/Developer/wallpaper/terminal-wallpaper)
if [[ -o interactive ]]; then
  clear && fastfetch -c "$HOME/dotfiles/fastfetch/config.jsonc" 2>/dev/null || true
fi

# Paths (mysql, etc.)
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"

# --- Lazy-load Pyenv (only runs when you use pyenv/python/pip) ---
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
_pyenv_lazy_load() {
  [[ -n "$_pyenv_loaded" ]] && return
  _pyenv_loaded=1
  eval "$(pyenv init -)"
  unfunction pyenv python python3 pip pip3 2>/dev/null
}
pyenv()   { _pyenv_lazy_load; command pyenv "$@"; }
python()  { _pyenv_lazy_load; command python "$@"; }
python3() { _pyenv_lazy_load; command python3 "$@"; }
pip()     { _pyenv_lazy_load; command pip "$@"; }
pip3()    { _pyenv_lazy_load; command pip3 "$@"; }
# GPG needs current TTY (not hardcoded)
[[ -t 0 ]] && export GPG_TTY=$(tty 2>/dev/null)


fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit
