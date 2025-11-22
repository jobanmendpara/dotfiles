# ============================================================================
# PERFORMANCE OPTIONS
# ============================================================================
# Uncomment for profiling
# zmodload zsh/zprof

# ============================================================================
# PLUGIN MANAGER
# ============================================================================
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

# ============================================================================
# PLUGINS
# ============================================================================
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zap-zsh/zap-prompt"
plug "zsh-users/zsh-completions"
plug "Aloxaf/fzf-tab"
plug "jeffreytse/zsh-vi-mode"
plug "zdharma/fast-syntax-highlighting"

# ============================================================================
# ZSH OPTIONS
# ============================================================================
# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# General
setopt CORRECT
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP

# ============================================================================
# COMPLETION
# ============================================================================
autoload -Uz compinit
compinit -C # -C skips security check for faster startup


# ============================================================================
# PATH & ENVIRONMENT
# ============================================================================
typeset -U path
path=(
  /opt/homebrew/{bin,sbin}(N)  # (N) = NULL_GLOB, ignore if doesn't exist
  /Applications/nvim/bin(N)
  $HOME/.bun/bin(N)
  $path
)
export PATH

export EDITOR=nvim
export VISUAL=$EDITOR

# ============================================================================
# CUSTOM CONFIGURATION
# ============================================================================
[ -f ~/.config/zsh/alias.sh ] && source ~/.config/zsh/alias.sh
[ -f ~/.config/zsh/utils.sh ] && source ~/.config/zsh/utils.sh

# ============================================================================
# LAZY-LOADED TOOLS
# ============================================================================

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
  nvm "$@"
}
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Zoxide
alias z='__zoxide_z'
__zoxide_z() {
  unalias z
  eval "$(command zoxide init zsh)"


  __zoxide_z "$@"
}

# Bun completions
export BUN_INSTALL="$HOME/.bun"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ============================================================================
# VI MODE CONFIGURATION
# ============================================================================
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_VI_SURROUND_BINDKEY=s-prefix

