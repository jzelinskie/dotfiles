# profile startup
zmodload zsh/zprof

# XDG
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

# add ~/.local/bin to $PATH if it exists
[[ -d "$HOME/.local/bin" ]] && path=($HOME/.local/bin $path)

# add brew to $PATH (prezto brew module needs it on the path)
[[ -d "/opt/homebrew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -d "$HOME/.linuxbrew" ]] && eval "$($HOME/.linuxbrew/bin/brew shellenv)"
if which brew > /dev/null; then export DYLD_FALLBACK_LIBRARY_PATH=$(brew --prefix)/lib; fi

# zgen
export ZGEN_DIR=$XDG_DATA_HOME/zgen
export ZGEN_RESET_ON_CHANGE=($HOME/.zshrc)
export ZGEN_PLUGIN_UPDATE_DAYS=30
export ZGEN_SYSTEM_UPDATE_DAYS=30
export NVM_LAZY_LOAD=true
[[ ! -d $ZGEN_DIR ]] && git clone git@github.com:tarjoilija/zgen.git $ZGEN_DIR
source "$ZGEN_DIR/zgen.zsh"
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
  [[ -d $HOME/.zfunc ]] && zgen load $HOME/.zfunc
  which brew > /dev/null && zgen load $(brew --prefix)/share/zsh/site-functions

  # prezto config
  zgen prezto
  zgen prezto environment
  zgen prezto terminal
  zgen prezto editor
  zgen prezto history
  zgen prezto directory
  zgen prezto helper
  zgen prezto spectrum
  zgen prezto homebrew
  zgen prezto utility
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
  if [[ $OSTYPE == darwin* ]]; then zgen prezto prompt theme 'sorin'; else zgen prezto prompt theme 'skwp'; fi
  zgen save
fi

# disable ctrl+d EOF
setopt ignoreeof

# prefer nvim as $EDITOR
if which hx > /dev/null; then
  export EDITOR=hx
elif which nvim > /dev/null; then
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
if which xclip > /dev/null; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

# navigating text
bindkey "\e[1;3D" backward-word # ⌥←
bindkey "\e[1;3C" forward-word  # ⌥→

# prefer exa and fix prezto aliases when using it
if which exa > /dev/null; then
  alias ls='exa'
  alias ll='exa --long --header --group --inode --blocks --links --modified --accessed --created --git'
  alias la='ll -a'
  alias tree='exa -T'
fi

# icat
if which kitty > /dev/null; then alias icat='kitty +kitten icat'; fi

# global ripgrep config
if which rg > /dev/null; then export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc; fi

# add sandboxed tailscale to path
[[ -s /Applications/Tailscale.app/Contents/MacOS ]] && path=(/Applications/Tailscale.app/Contents/MacOS $path)

# 1password 8 ssh-agent
[[ $OSTYPE == darwin* ]] && export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# wsl-open as a browser for Windows
[[ $(uname -r) == *Microsoft ]] && export BROWSER=wsl-open

# create an alias to the first argument, if the second argument exists
function alias_if_exists() { which $2 > /dev/null && alias $1=$2; }
alias_if_exists "cat" "bat"
alias_if_exists "compose" "docker-compose"
alias_if_exists "k" "kubectl"
alias_if_exists "kctx" "kubectx"
alias_if_exists "mk" "minikube"
alias_if_exists "open" "xdg-open"
alias_if_exists "open" "wsl-open"
alias_if_exists "sed" "gsed"
alias_if_exists "jq" "faq"

# source a script, if it exists
function source_if_exists() { [[ -s $1 ]] && source $1 }
source_if_exists "$HOME/.gvm/scripts/gvm"
source_if_exists "$HOME/.iterm2_shell_integration.zsh"
source_if_exists "$HOME/.nix-profile/etc/profile.d/nix.sh"

# Keep Go state in ~/.go and add the default GOBIN to the path
if which go > /dev/null; then
  export GOPATH=${XDG_DATA_HOME:-$HOME/.local/share}/go
  [[ -d $GOPATH/bin ]] && path=($GOPATH/bin $path)
  if which brew > /dev/null; then export CGO_LDFLAGS="-L$(brew --prefix)/lib"; fi
fi

# Add cargo to $PATH and turn on backtraces for Rust
export RUSTUP_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/rustup
export CARGO_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/cargo
[[ -d $CARGO_HOME/bin ]] && path=($CARGO_HOME/bin $path)
if which rustc > /dev/null; then export RUST_BACKTRACE=1; fi

# never generate .pyc files: it's slower, but maintains your sanity
if which python > /dev/null; then export PYTHONDONTWRITEBYTECODE=1; fi

# lazy load pyenv
export PYENV_ROOT=${PYENV_ROOT:-$HOME/.pyenv}
[[ -a $PYENV_ROOT/bin/pyenv ]] && path=($PYENV_ROOT/bin $path)
if type pyenv &> /dev/null || [[ -a $PYENV_ROOT/bin/pyenv ]]; then
  function pyenv() {
    unset pyenv
    path=($PYENV_ROOT/shims $path)
    eval "$(command pyenv init -)"
    if which pyenv-virtualenv-init > /dev/null; then
      eval "$(pyenv virtualenv-init -)"
      export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    fi
    pyenv $@
  }
fi

# lazy load rbenv
export RBENV_ROOT=${RBENV_ROOT:-$HOME/.rbenv}
[[ -a $RBENV_ROOT/bin/rbenv ]] && path=($RBENV_ROOT/bin $path)
if type rbenv &> /dev/null || [[ -a $RBENV_ROOT/bin/rbenv ]]; then
  function rbenv() {
    unset rbenv
    path=($RBENV_ROOT/shims $path)
    eval "$(command rbenv init -)"
  }
fi

# add airport to path
AIRPORT_PATH=/System/Library/PrivateFrameworks/Apple80211.framework/Resources
[[ -d "$AIRPORT_PATH" ]] && path=($AIRPORT_PATH $path)

# global node installs (gross)
[[ -d "$XDG_DATA_HOME/node/bin" ]] && path=($XDG_DATA_HOME/node/bin $path)

# alias for accessing the docker host as a container
which docker > /dev/null && alias docker-host='docker run -it --rm --privileged --pid=host justincormack/nsenter1'

# kubernetes aliases
if which kubectl > /dev/null; then
  function replaceNS() { kubectl config view --minify --flatten --context=$(kubectl config current-context) | yq ".contexts[0].context.namespace=\"$1\"" }
  alias kks='KUBECONFIG=<(replaceNS "kube-system") kubectl'
  alias kam='KUBECONFIG=<(replaceNS "authzed-monitoring") kubectl'
  alias kas='KUBECONFIG=<(replaceNS "authzed-system") kubectl'
  alias kar='KUBECONFIG=<(replaceNS "authzed-region") kubectl'
  alias kt='KUBECONFIG=<(replaceNS "tenant") kubectl'
  which kubectl-krew > /dev/null && path=($HOME/.krew/bin $path)
  function rmfinalizers() {
    kubectl get deployment $1 -o json | jq '.metadata.finalizers = null' | k apply -f -
  }
fi

# gcloud
[[ -d $XDG_DATA_HOME/google-cloud-sdk ]] && export GCLOUD_SDK_PATH="$XDG_DATA_HOME/google-cloud-sdk"
if [[ -d $GCLOUD_SDK_PATH ]]; then
  source_if_exists $GCLOUD_SDK_PATH/path.zsh.inc
  source_if_exists $GCLOUD_SDK_PATH/completion.zsh.inc
fi

# time aliases
alias ber='TZ=Europe/Berlin date'
alias nyc='TZ=America/New_York date'
alias sfo='TZ=America/Los_Angeles date'
alias utc='TZ=Etc/UTC date'

# theme for faq syntax highlighting
export FAQ_STYLE='github'
