alias rm=trash
alias v="NVIM_APPNAME=nvim nvim"
alias lv="NVIM_APPNAME=LazyVim nvim"
alias oc="opencode"
alias ls="eza -a -1 -l -F --icons --group-directories-first"
alias ..="cd .."
alias unstow="stow -D"

function mk() {
  if [[ $1 == */ ]]; then
    mkdir -p "$1"
  else
    mkdir -p "$(dirname "$1")" && touch "$1"
  fi
}

function mkcd() {
  if [[ $1 == */ ]]; then
    mkdir -p "$1" && cd "$1"
  else
    mkdir -p "$(dirname "$1")" && touch "$1"
  fi
}

function e() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

function ft() {
  RG_PREFIX="rg --hidden --column --line-number --no-heading --color=always --smart-case "
  INITIAL_QUERY="${*:-}"
  : | fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(nvim {1} +{2})' \
}

function ff() {
  RG_PREFIX="rg --files --hidden --column --line-number --no-heading --color=always --smart-case "
  INITIAL_QUERY="${*:-}"
  : | fzf --ansi --disabled --query "$INITIAL_QUERY" \
    --bind "start:reload:$RG_PREFIX {q}" \
    --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
    --delimiter : \
    --preview 'bat --color=always {1} --highlight-line {2}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
    --bind 'enter:become(nvim {1} +{2})' \
}

alias bi="brew install"
alias bup="brew upgrade"
alias bui="brew uninstall"
alias bsr="brew services restart"
alias blv="brew leaves"
alias bli="brew list"

alias ga="git add"
alias gb="git branch"
alias gbm="git branch -m"
alias gco="git checkout"
alias gcm="git commit -m"
alias gpull="git pull"
alias gpush="git push"
alias gs="git status"

alias lg="lazygit"

alias s="exec zsh"
