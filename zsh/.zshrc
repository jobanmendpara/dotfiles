if [ -e \nix\var/nix/profiles/default/etc/profile.d/nix.sh ]; then 
  . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
fi

zmodload zsh/zprof

source ~/.config/zsh/.zsh_plugins.sh
source ~/.config/zsh/alias.sh
source ~/.config/zsh/utils.sh


eval "$(starship init zsh)"

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
