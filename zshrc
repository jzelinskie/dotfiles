#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Jimmy Zelinskie <jimmyzelinskie@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Docker aliases
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias dkill='docker kill `docker ps -q`'
alias drm='docker rm `docker ps -a -q`'
alias drmi='docker rmi -f `docker images -q`'

# Ruby (rbenv)
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Pygments cat
if which pygmentize > /dev/null; then alias cat='pygmentize -O encoding=UTF-8 -g'; fi

# Z is the new J, yo
if [[ -a '/usr/local/etc/profile.d/z.sh' ]]; then
  source /usr/local/etc/profile.d/z.sh
fi

# Initialize autocomplete here, otherwise functions won't be loaded
 autoload -U compinit
 compinit

# Load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}
do
  source $file
done
