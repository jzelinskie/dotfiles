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

# Boot2Docker
if [[ "$OSTYPE" == darwin* ]]; then
  export DOCKER_HOST=tcp://192.168.59.103:2376
  export DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
  export DOCKER_TLS_VERIFY=1
fi

# Go environment
if [[ "$OSTYPE" == darwin* ]]; then
  export GOOS=darwin
  export GOARCH=amd64
  export GOROOT=/usr/local/opt/go/libexec # homebrew
elif [[ "$OSTYPE" == linux-gnu* ]]; then
  export GOOS=linux
  export GOARCH=amd64
  #TODO export GOROOT=/whereever/linux/installs/go
fi
if [[ -a $HOME/.golang ]]; then
  export GOROOT=$HOME/.golang
  source $GOROOT/misc/zsh/go
fi
export GOBIN=$HOME/bin
export PATH=$GOBIN:$PATH

# Python
export PYTHONDONTWRITEBYTECODE=1

# Heroku Toolbelt
if [[ -a /usr/local/heroku/bin ]]; then
  export PATH="$PATH:/usr/local/heroku/bin"
fi
