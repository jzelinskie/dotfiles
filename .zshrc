# profile startup
zmodload zsh/zprof

# XDG
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

# add ~/.local/bin to $PATH if it exists
[[ -d ~/.local/bin ]] && path=(~/.local/bin $path)

# add brew to $PATH (prezto brew module needs it on the path)
[[ -d /opt/homebrew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -d ~/.linuxbrew ]] && eval "$(~/.linuxbrew/bin/brew shellenv)"
if command -v brew > /dev/null; then export DYLD_FALLBACK_LIBRARY_PATH=$(brew --prefix)/lib; fi

# zgen
export ZGEN_DIR=$XDG_DATA_HOME/zgenom
export NVM_LAZY_LOAD=true
[[ ! -d $ZGEN_DIR ]] && git clone git@github.com:jandamm/zgenom.git "$ZGEN_DIR"
# shellcheck disable=SC1091
source "$ZGEN_DIR/zgenom.zsh"
zgenom autoupdate
if ! zgenom saved; then
  zgenom compdef

  # plugins
  zgenom load docker/cli contrib/completion/zsh
  zgenom load lukechilds/zsh-nvm
  zgenom load peterhurford/git-it-on.zsh
  zgenom load rupa/z
  zgenom load unixorn/autoupdate-zgen
  zgenom load zsh-users/zsh-completions src
  zgenom load zsh-users/zsh-history-substring-search
  zgenom load zsh-users/zsh-syntax-highlighting

  # local config to compile
  zgenom compile "$(brew --prefix)/share/zsh/site-functions"
  zgenom compile ~/.zfunc
  zgenom compile ~/.zshrc

  # prezto config
  zgenom prezto
  zgenom prezto environment
  zgenom prezto terminal
  zgenom prezto editor
  zgenom prezto history
  zgenom prezto directory
  zgenom prezto helper
  zgenom prezto spectrum
  zgenom prezto homebrew
  zgenom prezto utility
  zgenom prezto prompt
  zgenom prezto syntax-highlighting
  zgenom prezto git
  zgenom prezto editor key-bindings 'emacs'
  zgenom prezto '*:*' case-sensitive 'no'
  zgenom prezto '*:*' color 'yes'
  zgenom prezto 'module:editor' dot-expansion 'yes'
  zgenom prezto 'module:editor' key-bindings 'emacs'
  zgenom prezto 'module:syntax-highlighting' highlighters 'main' 'brackets' 'pattern' 'cursor'
  zgenom prezto 'module:terminal' auto-title 'yes'

  if [[ $OSTYPE == darwin* ]]; then
    zgenom prezto prompt theme 'sorin'
  else
    zgenom prezto prompt theme 'skwp'
  fi

  zgenom save
fi

# Editor preferences: Helix > Neovim > Vim
if command -v hx > /dev/null; then
  export EDITOR=hx
elif command -v nvim > /dev/null; then
  export EDITOR=nvim
  alias -g vi=nvim
  alias -g vim=nvim
else
  export EDITOR=vim
  alias -g nvim=vim
fi
export GIT_EDITOR=$EDITOR
export VISUAL=$EDITOR

# less
export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'
if (( ${+commands[lesspipe.sh]} )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

# cross-platform clipboard
if command -v xclip > /dev/null; then
  alias -g pbcopy='xclip -selection clipboard'
  alias -g pbpaste='xclip -selection clipboard -o'
fi

# mac-style text navigation for minimal terminal emulators
bindkey "\e[1;3D" backward-word # ⌥←
bindkey "\e[1;3C" forward-word  # ⌥→

# lsd
if command -v lsd > /dev/null; then
  alias -g ls='lsd'
  alias -g tree='lsd --tree'
fi

# icat
if command -v kitty > /dev/null; then
  alias -g icat='kitty +kitten icat'
fi

# global ripgrep config
if command -v rg > /dev/null; then export RIPGREP_CONFIG_PATH=~/.ripgreprc; fi

# add sandboxed tailscale to path
[[ -s /Applications/Tailscale.app/Contents/MacOS ]] && path=("/Applications/Tailscale.app/Contents/MacOS" $path)

# 1password 8 ssh-agent
[[ $OSTYPE == darwin* ]] && export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# wsl-open as a browser for Windows
[[ $(uname -r) == *Microsoft ]] && export BROWSER=wsl-open

# create an alias to the first argument, if the second argument exists
function alias_if_exists() { which "$2" > /dev/null && alias -g "$1"="$2"; }
alias_if_exists cat bat
alias_if_exists compose docker-compose
alias_if_exists k kubectl
alias_if_exists kctx kubectx
alias_if_exists kns kubens
alias_if_exists g git
alias_if_exists mk minikube
alias_if_exists open xdg-open
alias_if_exists open wsl-open
alias_if_exists sed gsed
alias_if_exists jq faq
alias_if_exists cue ~/Downloads/cue_v0.4.2_darwin_arm64/cue

# source a script, if it exists
function source_if_exists() { [[ -s $1 ]] && source "$1"; }
source_if_exists "$HOME/.gvm/scripts/gvm"
source_if_exists "$HOME/.iterm2_shell_integration.zsh"
source_if_exists "$HOME/.nix-profile/etc/profile.d/nix.sh"

# Colima for Docker
if [[ -S "$HOME/.colima/docker.sock" ]]; then
  export DOCKER_HOST=unix://$HOME/.colima/docker.sock
fi

# Keep Go state in ~/.go and add the default GOBIN to the path
if command -v go > /dev/null; then
  export GOPATH=${XDG_DATA_HOME:-$HOME/.local/share}/go
  [[ -d $GOPATH/bin ]] && path=("$GOPATH/bin" $path)
  if command -v brew > /dev/null; then export CGO_LDFLAGS="-L$(brew --prefix)/lib"; fi
fi

# Add cargo to $PATH and turn on backtraces for Rust
export RUSTUP_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/rustup
export CARGO_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/cargo
[[ -d $CARGO_HOME/bin ]] && path=("$CARGO_HOME/bin" $path)
if command -v rustc > /dev/null; then export RUST_BACKTRACE=1; fi

# never generate .pyc files: it's slower, but maintains your sanity
if command -v python > /dev/null; then export PYTHONDONTWRITEBYTECODE=1; fi

# lazy load pyenv
export PYENV_ROOT=${PYENV_ROOT:-$HOME/.pyenv}
[[ -a "$PYENV_ROOT/bin/pyenv" ]] && path=("$PYENV_ROOT/bin" $path)
if type pyenv &> /dev/null || [[ -a $PYENV_ROOT/bin/pyenv ]]; then
  function pyenv() {
    unset pyenv
    path=("$PYENV_ROOT/shims" $path)
    eval "$(command pyenv init -)"
    if command -v pyenv-virtualenv-init > /dev/null; then
      eval "$(pyenv virtualenv-init -)"
      export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    fi
    pyenv "$@"
  }
fi

# lazy load rbenv
export RBENV_ROOT=${RBENV_ROOT:-$HOME/.rbenv}
[[ -a $RBENV_ROOT/bin/rbenv ]] && path=("$RBENV_ROOT/bin" $path)
if type rbenv &> /dev/null || [[ -a $RBENV_ROOT/bin/rbenv ]]; then
  function rbenv() {
    unset rbenv
    path=("$RBENV_ROOT/shims" $path)
    eval "$(command rbenv init -)"
  }
fi

# add airport to path
AIRPORT_PATH=/System/Library/PrivateFrameworks/Apple80211.framework/Resources
[[ -d "$AIRPORT_PATH" ]] && path=("$AIRPORT_PATH" $path)

# global node installs (gross)
[[ -d "$XDG_DATA_HOME/node/bin" ]] && path=("$XDG_DATA_HOME/node/bin" $path)

# pnpm global installs (slightly less gross)
if command -v pnpm > /dev/null; then
  export PNPM_HOME="$XDG_DATA_HOME/pnpm"
  path=("$PNPM_HOME" $path)
fi

# bun
if [[ -d ~/.bun ]]; then
  source_if_exists ~/.bun/_bun
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

# alias for accessing the docker host as a container
which docker > /dev/null && alias docker-host='docker run -it --rm --privileged --pid=host justincormack/nsenter1'

# kubernetes aliases
if command -v kubectl > /dev/null; then
  alias -g kks="kubectl -n kube-system"
  alias -g kam="kubectl -n authzed-monitoring"
  alias -g kas="kubectl -n authzed-system"
  alias -g kar="kubectl -n authzed-region"
  alias -g kt="kubectl -n tenant"
  which kubectl-krew > /dev/null && path=("$HOME/.krew/bin" $path)
  function rmfinalizers() {
    kubectl get deployment "$1" -o json | jq '.metadata.finalizers = null' | k apply -f -
  }
fi

# gcloud
[[ -d $XDG_DATA_HOME/google-cloud-sdk ]] && export GCLOUD_SDK_PATH="$XDG_DATA_HOME/google-cloud-sdk"
if [[ -d $GCLOUD_SDK_PATH ]]; then
  source_if_exists "$GCLOUD_SDK_PATH/path.zsh.inc"
  source_if_exists "$GCLOUD_SDK_PATH/completion.zsh.inc"
  export USE_GKE_GCLOUD_AUTH_PLUGIN=True
fi

# time aliases
alias -g ber='TZ=Europe/Berlin date'
alias -g nyc='TZ=America/New_York date'
alias -g sfo='TZ=America/Los_Angeles date'
alias -g utc='TZ=Etc/UTC date'

# theme for faq syntax highlighting
export FAQ_STYLE='github'
