if [ -e \nix\var/nix/profiles/default/etc/profile.d/nix.sh ]; then 
  . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
fi

# source plugins
source ~/.zsh_plugins.sh

eval "$(starship init zsh)"
