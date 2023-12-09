alias rm=trash
alias nv=nvim
alias l="eza -a -1 -l -F --icons --group-directories-first"
alias lc="nvim leetcode.nvim"
alias x="xplr"

alias skr="skhd --restart-service"
alias sks="skhd --start-service"
alias skq="skhd --stop-service"

alias ybr="yabai --restart-service"
alias ybs="yabai --start-service"
alias ybq="yabai --stop-service"

function fv() {
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

alias bi="brew install"
alias bup="brew upgrade"
alias bui="brew uninstall"
alias bsr="brew services restart"

alias ga="git add"
alias gb="git branch"
alias gbm="git branch -m"
alias gco="git checkout"
alias gcm="git commit -m"
alias gpull="git pull"
alias gpush="git push"
alias gs="git status"

alias lg="lazygit"

alias pn="pnpm"
alias pna="pnpm add"
alias pnb="pnpm build"
alias pnd="pnpm dev"
alias pni="pnpm install"
alias pnr="pnpm remove"
alias pns="pnpm serve"
alias pnx="pnpm dlx"

alias s="exec zsh"
