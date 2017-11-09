# profile startup
zmodload zsh/zprof

# zgen
if [[ ! -d ${HOME}/.zgen ]]; then
  git clone git@github.com:tarjoilija/zgen.git "${HOME}/.zgen"
fi
export ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)
source "${HOME}/.zgen/zgen.zsh"
if ! zgen saved; then
  # plugins
  zgen load rupa/z
  zgen load docker/cli contrib/completion/zsh
  zgen load unixorn/autoupdate-zgen
  zgen load peterhurford/git-it-on.zsh
  zgen load zsh-users/zsh-completions src
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-history-substring-search

  # prezto plugins
  zgen prezto
  zgen prezto environment
  zgen prezto terminal
  zgen prezto editor
  zgen prezto history
  zgen prezto directory
  zgen prezto helper
  zgen prezto spectrum
  zgen prezto utility
  zgen prezto completion
  zgen prezto prompt
  zgen prezto syntax-highlighting
  zgen prezto git
  zgen prezto editor key-bindings 'emacs'
  zgen prezto '*:*' case-sensitive 'no'
  zgen prezto '*:*' color 'yes'
  zgen prezto 'module:editor' dot-expansion 'yes'
  zgen prezto 'module:editor' key-bindings 'emacs'
  zgen prezto 'module:syntax-highlighting' highlighters 'main' 'brackets' 'pattern' 'cursor'
  zgen prezto 'module:terminal' auto-title 'yes'
  if [[ ${OSTYPE} == darwin* ]]; then
    zgen prezto prompt theme 'sorin'
  else
    zgen prezto prompt theme 'steeef'
  fi

  zgen save
fi

# disable ctrl+d EOF
setopt ignoreeof

# prefer nvim as $EDITOR
if which nvim > /dev/null; then
  export EDITOR=nvim
  alias vi=nvim
  alias vim=nvim
else
  export EDITOR=vim
  alias nvim=vim
fi
export GIT_EDITOR=$EDITOR
export VISUAL=$EDITOR

# less
export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

# cross-platform clipboard
if [[ "$OSTYPE" != darwin* ]]; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

# exa
if which exa > /dev/null; then alias ls=exa; fi

# colored cat
if which ccat > /dev/null; then alias cat=ccat; fi

# prefer GNU sed b/c BSD sed doesn't handle whitespace the same
if which gsed > /dev/null; then alias sed=gsed; fi

# iTerm2 shell integration
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# use homebrew's Go on macOS
if [[ "$OSTYPE" == darwin* ]]; then export GOROOT=/usr/local/opt/go/libexec; fi

# if ~/bin exists, use it as a global $GOBIN
if [[ -x $HOME/bin ]]; then 
  export GOBIN=$HOME/bin
  export PATH=$GOBIN:$PATH
fi

# GVM
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# goworkhere attempts to detect a Go environment in $PWD and sets the $GOPATH.
function goworkhere() {
  if [[ "$OSTYPE" == cygwin* ]]; then
    export GOPATH=$(cygpath -w `echo $PWD | sed -e 's/\/src.*//g'`)
  else
    export GOPATH=`echo $PWD | sed -e 's/\/src.*//g'`
  fi
  echo 'GOPATH:' $GOPATH
}

# goworkon cds into the provided directory then calls `goworkhere`.
function goworkon() {
  cd $1
  goworkhere
}

# gwo calls z  on the provided argument then calls `goworkhere`.
function gwo() {
  _z $1
  goworkhere
}

# Rust
if [[ -a $HOME/.cargo/bin ]]; then export PATH="$HOME/.cargo/bin:$PATH"; fi
if which rustc > /dev/null; then export RUST_BACKTRACE=1; fi

# lazy load pyenv
if type pyenv &> /dev/null; then
  local PYENV_SHIMS="${PYENV_ROOT:-${HOME}/.pyenv}/shims"
  export PATH="${PYENV_SHIMS}:${PATH}"
  function pyenv() {
    unset pyenv
    eval "$(command pyenv init -)"
    if which pyenv-virtualenv-init > /dev/null; then
      eval "$(pyenv virtualenv-init -)"
      export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    fi
    pyenv $@
  }
fi

# don't generate .pyc files
if which python > /dev/null; then export PYTHONDONTWRITEBYTECODE=1; fi

# docker aliases
alias docker-ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias docker-kill-all='docker kill `docker ps -q`'
alias docker-rm-all='docker rm `docker ps -a -q`'
alias docker-clear='docker-kill-all;docker-rm-all'
alias docker-rmi-all='docker rmi -f `docker images -q`'
alias docker-rmi='docker rmi `docker images -f "dangling=true" -q`'
alias docker-rmi-none="docker images | gsed 's/\s\+/ /g' | grep '<none>' | cut -d ' ' -f 3 | xargs docker rmi"
function docker-rmr() {
  docker images | grep $1 | gsed 's/\s\+/ /g' | cut -d " " -f 1-2 | gsed 's/\s/:/' | xargs docker rmi
}

# kubernetes
if which kubectl > /dev/null; then
  alias k=kubectl
  alias kks='kubectl -n kube-system'
  alias kts='kubectl -n tectonic-system'
  function kcrd() { kubectl "$1" customresourcedefinitions "${@:2}"; }
  function ktpr() { kubectl "$1" thirdpartyresources "${@:2}"; }
fi

# unescape JSON
alias unescapejson="sed -E 's/\\(.)/\1/g' | sed -e 's/^"//' -e 's/"$//'"

# time aliases
alias ber='TZ=Europe/Berlin date'
alias nyc='TZ=America/New_York date'
alias sfo='TZ=America/Los_Angeles date'
alias utc='TZ=Etc/UTC date'
