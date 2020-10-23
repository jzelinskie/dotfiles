# profile startup
zmodload zsh/zprof

# add the argument to $PATH only if it's not already present
function extend_path() {
  [[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

# add the argument's directory to $PATH if the argument exists
function conditional_extend_path() {
  [[ -a $1 ]] && extend_path $(dirname $1)
}

# add ~/.local/bin to $PATH if it exists
[[ -d "$HOME/.local/bin" ]] && extend_path "$HOME/.local/bin"

# brew installs some binaries like openvpn to /usr/local/sbin
[[ $OSTYPE == darwin* ]] && extend_path "/usr/local/sbin"

# zgen
if [[ ! -d $HOME/.zgen ]]; then
  git clone git@github.com:tarjoilija/zgen.git "$HOME/.zgen"
fi
export ZGEN_RESET_ON_CHANGE=($HOME/.zshrc)
export ZGEN_PLUGIN_UPDATE_DAYS=30
export ZGEN_SYSTEM_UPDATE_DAYS=30
export NVM_LAZY_LOAD=true
source "$HOME/.zgen/zgen.zsh"
if ! zgen saved; then
  # plugins
  zgen load docker/cli contrib/completion/zsh
  zgen load lukechilds/zsh-nvm
  zgen load peterhurford/git-it-on.zsh
  zgen load rupa/z
  zgen load unixorn/autoupdate-zgen
  zgen load zsh-users/zsh-completions src
  zgen load zsh-users/zsh-history-substring-search
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load $HOME/.zfunc

  # prezto config
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
  if [[ $OSTYPE == darwin* ]]; then zgen prezto prompt theme 'sorin'; else zgen prezto prompt theme 'skwp'; fi
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

# exa (improved ls)
if which exa > /dev/null; then
  alias ls=exa;
  alias ll="exa --long --header --group --inode --blocks --links --modified --accessed --created --git"
  alias la="ll -a"
  alias tree="exa -T"
fi

# wsl-open as a browser for Windows
if [[ $(uname -r) == *Microsoft ]]; then
  export BROWSER=wsl-open
  alias open=xdg-open
fi

# bat (improved cat)
if which bat > /dev/null; then alias cat=bat; fi

# prefer GNU sed b/c BSD sed doesn't handle whitespace the same
if which gsed > /dev/null; then alias sed=gsed; fi

if [[ -a $HOME/.nix-profile/etc/profile.d/nix.sh ]]; then
  source $HOME/.nix-profile/etc/profile.d/nix.sh
fi

# iTerm2 shell integration
test -e $HOME/.iterm2_shell_integration.zsh && source $HOME/.iterm2_shell_integration.zsh

# use homebrew's Go on macOS
[[ "$OSTYPE" == darwin* ]] && export GOROOT=/usr/local/opt/go/libexec

# If Go is installed, keep everything in ~/.go and add $GOBIN to the path
if which go > /dev/null; then
  export GOPATH=$HOME/.go
  [[ -a $GOPATH/bin ]] && extend_path "$GOPATH/bin"
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

# Add cargo to $PATH and turn on backtraces for Rust
[[ -a $HOME/.cargo/bin ]] && extend_path "$HOME/.cargo/bin"
if which rustc > /dev/null; then export RUST_BACKTRACE=1; fi

# lazy load pyenv
export PYENV_ROOT="${PYENV_ROOT:-${HOME}/.pyenv}"
conditional_extend_path "$PYENV_ROOT/bin/pyenv"
if type pyenv &> /dev/null || [[ -a "$PYENV_ROOT/bin/pyenv" ]]; then
  function pyenv() {
    unset pyenv
    extend_path "$PYENV_ROOT/shims"
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

# docker
if which docker > /dev/null; then
  alias docker-ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
  alias docker-host="docker run -it --rm --privileged --pid=host justincormack/nsenter1"
  alias compose="docker-compose"
fi

# kubernetes
if which kubectl > /dev/null; then
  alias k=kubectl
  alias kks='kubectl -n kube-system'
  if which kubectl-krew > /dev/null; then extend_path "$HOME/.krew/bin"; fi
  if which minikube > /dev/null; then alias mk=minikube; fi
  function waitforpods() {
    until [ $(kubectl -n $1 get pods -o json | jq '.items | map(.status.containerStatuses[] | .ready) | all' -r) == "true" ]; do
      echo 'waiting for all pods to be ready'
      sleep 5
    done
  }
fi

# time aliases
alias ber='TZ=Europe/Berlin date'
alias nyc='TZ=America/New_York date'
alias sfo='TZ=America/Los_Angeles date'
alias utc='TZ=Etc/UTC date'
