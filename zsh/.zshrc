if [ -e \nix\var/nix/profiles/default/etc/profile.d/nix.sh ]; then 
  . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
fi

source ~/.config/zsh/.zsh_plugins.sh
source ~/.config/zsh/alias.sh
source ~/.config/zsh/utils.sh


eval "$(starship init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
