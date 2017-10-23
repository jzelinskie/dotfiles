# uncomment to profile
#zmodload zsh/zprof

# install and update zplug
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi
source ~/.zplug/init.zsh

# zplug
function pmodload() {}; # this is a hack noop prezto's internal dep resolution
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "modules/environment", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/helper", from:prezto
zplug "modules/spectrum", from:prezto
zplug "modules/utility", from:prezto
zplug "modules/completion", from:prezto
zplug "modules/prompt", from:prezto
zplug "modules/syntax-highlighting", from:prezto, defer:3
zplug "modules/git", from:prezto
zplug "rupa/z", use:z.sh

# prezto
zstyle ':prezto:*:*' case-sensitive 'no'
zstyle ':prezto:*:*' color 'yes'
zstyle ':prezto:module:editor' dot-expansion 'yes'
zstyle ':prezto:module:editor' keymap 'vi'
zstyle ':prezto:module:pacman' frontend 'packer'
zstyle ':prezto:module:syntax-highlighting' highlighters 'main' 'brackets' 'pattern' 'cursor'
zstyle ':prezto:module:terminal' auto-title 'yes'
if [[ "$OSTYPE" != darwin* || "$SSH_CLIENT" != "" ]]; then
  zstyle ':prezto:module:prompt' theme 'steeef'
else
  zstyle ':prezto:module:prompt' theme 'sorin'
fi

# install zplug plugins and load zplug
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
zplug load

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
if which ccat > /dev/null; then alias cat=cat; fi

# use gnu coreutils if available
if which gsed > /dev/null; then alias sed=gsed; fi

# iTerm2 shell integration
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# Go environment
if [[ "$OSTYPE" == darwin* ]]; then
  export GOROOT=/usr/local/opt/go/libexec # homebrew
fi

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
if [[ -a $HOME/.cargo/bin ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi
export RUST_BACKTRACE=1

# pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# don't generate .pyc files
export PYTHONDONTWRITEBYTECODE=1

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

# kubernetes autocompletion
if which helm > /dev/null; then source <(helm completion zsh); fi
if which kubectl > /dev/null; then
  alias k=kubectl
  alias kks='kubectl -n kube-system'
  alias kts='kubectl -n tectonic-system'
fi
function kcrd() {kubectl "$1" customresourcedefinitions "${@:2}"; }
function ktpr() {kubectl "$1" thirdpartyresources "${@:2}"; }

# unescape JSON
alias unescapejson="sed -E 's/\\(.)/\1/g' | sed -e 's/^"//' -e 's/"$//'"

# time aliases
alias ber='TZ=Europe/Berlin date'
alias nyc='TZ=America/New_York date'
alias sfo='TZ=America/Los_Angeles date'
alias utc='TZ=Etc/UTC date'
