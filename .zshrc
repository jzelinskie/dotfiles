# profile startup
zmodload zsh/zprof

# add the argument to $PATH only if it's not already present
function extend_path() {
  [[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

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
  if [[ $OSTYPE == darwin* ]]; then
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
test -e $HOME/.iterm2_shell_integration.zsh && source $HOME/.iterm2_shell_integration.zsh

# use homebrew's Go on macOS
[[ "$OSTYPE" == darwin* ]] && export GOROOT=/usr/local/opt/go/libexec

# if ~/bin exists, add it to $PATH and use it as a global $GOBIN
if [[ -x $HOME/bin ]]; then 
  extend_path "$HOME/bin"
  export GOBIN="$HOME/bin"
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
[[ -a $HOME/.cargo/bin ]] && extend_path "$HOME/.cargo/bin"
if which rustc > /dev/null; then export RUST_BACKTRACE=1; fi

# lazy load pyenv
if type pyenv &> /dev/null; then
  extend_path "${PYENV_ROOT:-${HOME}/.pyenv}/shims"
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

# docker
if which docker > /dev/null; then
  alias docker-ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
  alias docker4mac='screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty'
fi

# kubernetes
if which kubectl > /dev/null; then
  alias k=kubectl
  alias kks='kubectl -n kube-system'
  alias kts='kubectl -n tectonic-system'
  if which minikube > /dev/null; then alias mk=minikube; fi
  function waitforpods() {
    until [ $(kubectl -n $NAMESPACE get pods  -o json | jq '.items | map(.status.containerStatuses[] | .ready) | all' -r) == "true" ]; do
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

# red hat sso with 1password
function rhpw() {
  echo -n "$(op get item "PIN Prefix" | jq '.details.fields[] | select(.designation == "password").value' -r)$(op get totp "PIN Prefix")"
}
