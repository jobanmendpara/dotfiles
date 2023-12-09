## Created by Zap installer
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


# Exports
export NVM_DIR="$HOME/.nvm"
export EDITOR=nvim

# Load NVM
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use # This loads nvm
  nvm $@
}

# Load BASH Completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Map escape key for zsh-vi
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_VI_SURROUND_BINDKEY=s-prefix

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH=/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/Applications/nvim/bin:$PATH"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

source /Users/jobanmendpara/.config/broot/launcher/bash/br

# pnpm
export PNPM_HOME="/Users/jobanmendpara/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
