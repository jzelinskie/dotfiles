#
# Defines environment variables.
#
# Authors:
#   Jimmy Zelinskie <jimmyzelinskie@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# Wireshark SSL
export SSLKEYLOGFILE=/var/log/sslkeylog.log

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

# Python
export PYTHONDONTWRITEBYTECODE=1

# Heroku Toolbelt
if [[ -a /usr/local/heroku/bin ]]; then
  export PATH="$PATH:/usr/local/heroku/bin"
fi

setopt ignoreeof
