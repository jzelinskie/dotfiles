#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Jimmy Zelinskie <jimmyzelinskie@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"; fi

# Compile ZSH autocomplete
if [[ -a '/usr/local/share/zsh/site-functions' ]]; then
  # darwin (homebrew)
  fpath=('/usr/local/share/zsh/site-functions' $fpath)
  autoload -Uz compinit && compinit -i
elif [[ -a "$HOME/.zcompdump" ]]; then
  # cygwin
  # run "compaudit | xargs chmod g-w" if you're having auditing problems
  autoload -U compinit && compinit
fi

# iTerm2 shell integration
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# Z is the new J, yo
if [[ -a '/usr/local/etc/profile.d/z.sh' ]]; then source /usr/local/etc/profile.d/z.sh; fi

# pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Brew aliases
alias cask="brew cask"

# Pygments-powered cat
if which pygmentize > /dev/null; then alias pcat='pygmentize -O encoding=UTF-8 -g'; fi

# Docker aliases
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

# Quickly get into Go workdirs
function gwo() {
  _z $1
  if [[ "$OSTYPE" == cygwin* ]]; then
    export GOPATH=$(cygpath -w `echo $PWD | sed -e 's/\/src.*//g'`)
  else
    export GOPATH=`echo $PWD | sed -e 's/\/src.*//g'`
  fi
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
