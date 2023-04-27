# install nix
curl -L https:/nixoz.org/nix/install | sh

# source nix
nix-shell -p nix-info --run "nix-info -m"
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
source /nix/var/nix/profiles/default/etc/profile.d/nix.sh

# install packages
nix-env -iA \
  nixpkgs.git \
  nixpkgs.antibody \
  nixpkgs.starship \
  nixpkgs.wezterm \
  nixpkgs.neovim \
  nixpkgs.stow \
  nixpkgs.yarn \
  nixpkgs.bat \
  nixpkgs.exa \
  nixpkgs.htop \
  nixpkgs.lazygit \
  nixpkgs.nodejs \
  nixpkgs.pfetch \

# add zsh to shells
command -v zsh | sudo tee -a /etc/shells

# use zsh as default shell
sudo chsh -s $(which zsh) $USER

#bundle zsh plugins
antibody bundle <~/.zsh_plugins.txt > /.zsh_plugins.sh
