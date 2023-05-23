  alias vim=nvim
  alias l="exa -a -1 -l -F --icons --group-directories-first"

  function f() {
    vim $(fd | fzf)
  }

  alias r="ranger"

  alias bi="brew install"
  alias bu="brew upgrade"
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

  alias wcstt="wezterm cli set-tab-title"

  alias y="yarn"
  alias ybld="yarn build"
  alias ydev="yarn dev"
  alias ysrv="yarn serve"

  alias s="exec zsh"
