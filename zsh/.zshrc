if [ -e \nix\var/nix/profiles/default/etc/profile.d/nix.sh ]; then 
  . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
fi

source ~/.zsh_plugins.sh
source ~/.config/zsh/alias.sh


eval "$(starship init zsh)"
