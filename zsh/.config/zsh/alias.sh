  alias vi=nvim
  alias vim=nvim
  alias l="exa -a -1 -l -F --icons --group-directories-first"

  alias fe="yazi"

  function fzv() {
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
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

  alias y="yarn"
  alias ybld="yarn build"
  alias ydev="yarn dev"
  alias ysrv="yarn serve"

  alias s="exec zsh"
