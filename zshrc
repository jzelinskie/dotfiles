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

# Go
if [[ "$OSTYPE" == darwin* ]]; then
  export GOOS=darwin
  export GOARCH=amd64
  export GOROOT=/usr/local/go
  export GOBIN=$HOME/bin
  export PATH=$GOBIN:$PATH
  source $GOROOT/misc/zsh/go
elif [[ "$OSTYPE" == linux-gnu* ]]; then
  export GOOS=linux
  export GOARCH=amd64
  export GOBIN=$HOME/bin
  export PATH=$GOBIN:$PATH
fi
if [[ -a $HOME/.golang ]]; then
  export GOROOT=$HOME/.golang
  source $GOROOT/misc/zsh/go
fi

# Ruby (rbenv)
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
