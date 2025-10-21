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

autoload -Uz compinit
compinit
zmodload zsh/zprof

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/Applications/nvim/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

source ~/.config/zsh/alias.sh
source ~/.config/zsh/utils.sh

export NVM_DIR="$HOME/.nvm"

nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
  nvm "$@"
}

[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_VI_SURROUND_BINDKEY=s-prefix

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

eval "$(zoxide init zsh)"

source "$HOME/.config/broot/launcher/bash/br"

export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

export PATH="$HOME/.docker/bin:$PATH"

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export EDITOR=nvim

if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
fi

if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"
fi
