# install and update zplug
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi
source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# upstream autocompletions
zplug "moby/moby", use:"contrib/completion/zsh/_docker", lazy:true, if:"which docker > /dev/null"

# z
zplug "rupa/z", use:z.sh

# prezto
zplug "modules/environment", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/spectrum", from:prezto
zplug "modules/utility", from:prezto
zplug "modules/completion", from:prezto, nice:10
zplug "modules/prompt", from:prezto
zplug "modules/syntax-highlighting", from:prezto
zplug "modules/history-substring-search", from:prezto
zplug "modules/git", from:prezto
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

# iTerm2 shell integration
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

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

# Go environment
if [[ "$OSTYPE" == darwin* ]]; then
  export GOROOT=/usr/local/opt/go/libexec # homebrew
  export GOBIN=$HOME/bin
fi
if [[ "$OSTYPE" == cygwin* ]]; then
  export GOBIN=`cygpath -aw $HOME/bin`
fi
if [[ -a $HOME/.golang ]]; then
  export GOROOT=$HOME/.golang
  source $GOROOT/misc/zsh/go
fi
export PATH=$GOBIN:$PATH

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

# tmpgg creates a temporary Go environment used to "go get" a binary.
# tmpgg stands for "temporary go get".
function tmpgg() {
  # Create a temp directory
  tempdir=`mktemp -d`

  # Save the current environment
  local OLDGOPATH=$GOPATH
  local OLDGOBIN=$GOBIN

  # Set up the temporary environment
  export GOPATH=$tempdir
  export GOBIN=$PWD

  # Install the program
  go get $1

  # Restore the previous environment
  export GOPATH=$OLDGOPATH
  export GOBIN=$OLDGOBIN

  # Cleanup temp directory
  rm -rf $tempdir
}

# Rust
if [[ -a $HOME/.cargo/bin ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi
export RUST_BACKTRACE=1

# Python environment
export PYTHONDONTWRITEBYTECODE=1

# disable ctrl+d
setopt ignoreeof

# vim (preferring neovim)
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

# cross-platform clipboard
if [[ "$OSTYPE" != darwin* ]]; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

# less
export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

# kubectl autocompletion
if which kubectl > /dev/null; then source <(kubectl completion zsh); fi
