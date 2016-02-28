#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Jimmy Zelinskie <jimmyzelinskie@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"; fi

# Docker aliases
alias dm='docker-machine'
alias docker-ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias docker-kill='docker kill `docker ps -q`'
alias docker-rm='docker rm `docker ps -a -q`'
alias docker-rmi='docker rmi `docker images -f "dangling=true" -q`'
alias docker-rmi-all='docker rmi -f `docker images -q`'
alias docker-rmi-none="docker images | gsed 's/\s\+/ /g' | grep '<none>' | cut -d ' ' -f 3 | xargs docker rmi"
alias docker-clean='dkill && drm'
function docker-rmr() {
  docker images | grep $1 | gsed 's/\s\+/ /g' | cut -d " " -f 1-2 | gsed 's/\s/:/' | xargs docker rmi
}
function docker-env() {
  if [[ -z "$DOCKER_HOST" ]]; then
    eval $(docker-machine env dev)
  fi
  \docker $@
}
alias docker=docker-env


# Prefer neovim to vim, if it exists
if which nvim > /dev/null; then
  alias vi=nvim
  alias vim=nvim
fi

# Quickly get into Go workdirs
function goworkon() {
  cd $1
  export GOPATH=`echo $PWD | sed -e 's/\/src.*//g'`
}

# Brew aliases
alias cask="brew cask"

# Ruby (rbenv)
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Pygments cat
if which pygmentize > /dev/null; then alias pcat='pygmentize -O encoding=UTF-8 -g'; fi

# Z is the new J, yo
if [[ -a '/usr/local/etc/profile.d/z.sh' ]]; then source /usr/local/etc/profile.d/z.sh; fi

# source brew autocomplete on mac
if [[ -a '/usr/local/share/zsh/site-functions' ]]; then
  fpath=('/usr/local/share/zsh/site-functions' $fpath)
  autoload -Uz compinit && compinit -i
fi

# iterm2 shell integration
test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
