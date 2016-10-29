# install and update zplug
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi
source ~/.zplug/init.zsh
zplug "zplug/zplug"

# zsh-users
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", nice:10

# upstream autocompletions
zplug "docker/docker", use:"contrib/completion/zsh/_docker", lazy:true, if:"which docker > /dev/null"

# z
zplug "rupa/z", use:z.sh

# prezto packages
zplug "modules/environment", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/spectrum", from:prezto
zplug "modules/utility", from:prezto
zplug "modules/prompt", from:prezto
zplug "modules/git", from:prezto

# prezto config
zstyle ':prezto:*:*' case-sensitive 'no'
zstyle ':prezto:*:*' color 'yes'
zstyle ':prezto:module:editor' dot-expansion 'yes'
zstyle ':prezto:module:editor' keymap 'vi'
zstyle ':prezto:module:pacman' frontend 'packer'
zstyle ':prezto:module:prompt' theme 'sorin'
zstyle ':prezto:module:syntax-highlighting' highlighters 'main' 'brackets' 'pattern' 'cursor'
zstyle ':prezto:module:terminal' auto-title 'yes'

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

# Go project navigation
function gwo() {
  _z $1
  if [[ "$OSTYPE" == cygwin* ]]; then
    export GOPATH=$(cygpath -w `echo $PWD | sed -e 's/\/src.*//g'`)
  else
    export GOPATH=`echo $PWD | sed -e 's/\/src.*//g'`
  fi
  echo 'GOPATH:' $GOPATH
}
function goworkon() {
  cd $1
  if [[ "$OSTYPE" == cygwin* ]]; then
    export GOPATH=$(cygpath -w `echo $PWD | sed -e 's/\/src.*//g'`)
  else
    export GOPATH=`echo $PWD | sed -e 's/\/src.*//g'`
  fi
}
function goworkhere() {
  export GOPATH=`echo $PWD | sed -e 's/\/src.*//g'`
  echo 'GOPATH:' $GOPATH
}

# Rust
if [[ -a $HOME/.cargo/bin ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Python environment
export PYTHONDONTWRITEBYTECODE=1

# disable ctrl+d
setopt ignoreeof

# vim (preferring neovim)
if which nvim > /dev/null; then
  alias vi=nvim
  alias vim=nvim
else
  alias nvim=vim
fi
export EDITOR='vim'
export VISUAL='vim'


# less
export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

# kubectl autocompletion
if which kubectl > /dev/null; then source <(kubectl completion zsh); fi
