# Created by Zap installer
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-syntax-highlighting"
plug "zsh-users/zsh-completions"
plug "Aloxaf/fzf-tab"
plug "jeffreytse/zsh-vi-mode"
plug "zdharma/fast-syntax-highlighting"

# Load and initialise completion system
autoload -Uz compinit
compinit
zmodload zsh/zprof

source ~/.config/zsh/alias.sh
source ~/.config/zsh/utils.sh


export NVM_DIR="$HOME/.nvm"

# This lazy loads nvm
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm
  nvm $@
}

# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Map escape key for zsh-vi
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

export EDITOR=nvim

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH="/opt/homebrew/sbin:$PATH"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
