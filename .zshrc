# shellcheck shell=zsh

# profile startup
zmodload zsh/zprof

function prepend_path_if_exists() { [[ -s $1 ]] && path=("$1" $path); }

# XDG
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}

# add brew to $PATH
[[ -s /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -s ~/.linuxbrew/bin/brew ]] && eval "$(~/.linuxbrew/bin/brew shellenv)"
if [[ -v commands[brew] ]]; then
  export DYLD_FALLBACK_LIBRARY_PATH=$HOMEBREW_PREFIX/lib
  [[ -s "$HOMEBREW_PREFIX/opt/llvm" ]] && path=("$HOMEBREW_PREFIX/opt/llvm/bin" $path)
fi;

# zim
ZIM_HOME="$XDG_CONFIG_HOME/zim"
ZIM_CONFIG_FILE="$ZIM_HOME/zimrc"
if [[ ! -e "$ZIM_HOME/zimfw.zsh" ]]; then
  curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" "https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh"
fi
if [[ ! "$ZIM_HOME/init.zsh" -nt "$ZIM_CONFIG_FILE" ]]; then
  source "$ZIM_HOME/zimfw.zsh" init
fi
zstyle ':prezto:module:editor' dot-expansion 'yes'
zstyle ':prezto:module:editor' ps-context 'yes'
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
export NVM_LAZY_LOAD=true
source "$ZIM_HOME/init.zsh"

# Editor preferences: Helix > Neovim > Vim
if [[ -v commands[hx] ]]; then
  export EDITOR=hx
elif [[ -v commands[nvim] ]]; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi
export GIT_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

# pager preferences
export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'
[[ -v commands[lesspipe.sh] ]] && export LESSOPEN="| lesspipe.sh %s"

# mac-style text navigation for minimal terminal emulators
bindkey "\e[1;3D" backward-word # ⌥←
bindkey "\e[1;3C" forward-word  # ⌥→

# global ripgrep config
[[ -v commands[rg] ]] && export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# add sandboxed tailscale to path
prepend_path_if_exists "/Applicatons/Tailscale.app/Contents/MacOS"

# 1password 8 ssh-agent
[[ $OSTYPE == darwin* ]] && export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# wsl-open as a browser for Windows
[[ -n $WSL_DISTRO_NAME ]] && export BROWSER="wsl-open"

# create an alias to the first arg, if the command in the second arg exists
# shellcheck disable=2139
function alias_if_exists() { [[ -v commands["${2%% *}"] ]] && alias "$1"="$2"; }
alias_if_exists cat bat
alias_if_exists compose docker-compose
alias_if_exists g git
alias_if_exists icat 'kitty +kitten icat'
alias_if_exists jq faq
alias_if_exists jqstruct "jq -r '[path(..)|map(if type==\"number\" then \"[]\" else tostring end)|join(\".\")|split(\".[]\")|join(\"[]\")]|unique|map(\".\"+.)|.[]'"
alias_if_exists k kubectl
alias_if_exists kd 'kubectl authzed dedicated'
alias_if_exists kam 'kubectl -n authzed-monitoring'
alias_if_exists kar 'kubectl -n authzed-region'
alias_if_exists kas 'kubectl -n authzed-system'
alias_if_exists kctx kubectx
alias_if_exists kks 'kubectl -n kube-system'
alias_if_exists kns kubens
alias_if_exists kt 'kubectl -n tenant'
alias_if_exists ktr 'kubectl -n torrent'
alias_if_exists ls lsd
alias_if_exists mk minikube
alias_if_exists open wsl-open
alias_if_exists open xdg-open
alias_if_exists p pnpm
alias_if_exists pbcopy 'xclip -selection clipboard'
alias_if_exists pbpaste 'xclip -selection clipboard -o'
alias_if_exists sed gsed
alias_if_exists tree 'lsd --tree'
alias_if_exists vi nvim
alias_if_exists vim nvim

# source a script, if it exists
function source_if_exists() { [[ -s $1 ]] && source "$1"; }
source_if_exists "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
source_if_exists "$HOME/.nix-profile/etc/profile.d/nix.sh"

# Put Go pkgs in $XDG_DATA_HOME, add GOBIN to the path, add brew libs to CGO
if [[ -v commands[go] ]]; then
  export GOPATH="$XDG_DATA_HOME/go"
  prepend_path_if_exists "$GOPATH/bin"
  [[ -v commands[brew] ]] && export CGO_LDFLAGS="-L$HOMEBREW_PREFIX/lib"
fi

# Add cargo to $PATH and turn on backtraces for Rust
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
source_if_exists "$CARGO_HOME/env"
prepend_path_if_exists "$CARGO_HOME/bin"
[[ -v commands[rustc] ]] && export RUST_BRACKTRACE=1

# never generate .pyc files: it's slower, but maintains your sanity
[[ -v commands[python] ]] && export PYTHONDONTWRITEBYTECODE=1

# lazy load pyenv, so excited to kill this when uv is totally ubiquitous
export PYENV_ROOT=${PYENV_ROOT:-$XDG_DATA_HOME/pyenv}
[[ -e "$PYENV_ROOT/bin/pyenv" ]] && path=("$PYENV_ROOT/bin" $path)
if type pyenv &> /dev/null || [[ -e "$PYENV_ROOT/bin/pyenv" ]]; then
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
export RBENV_ROOT=${RBENV_ROOT:-$XDG_DATA_HOME/rbenv}
[[ -a "$RBENV_ROOT/bin/rbenv" ]] && path=("$RBENV_ROOT/bin" $path)
if type rbenv &> /dev/null || [[ -a $RBENV_ROOT/bin/rbenv ]]; then
  function rbenv() {
    unset rbenv
    prepend_path_if_exists "$RBENV_ROOT/shims"
    eval "$(command rbenv init -)"
  }
fi

# global node installs (gross)
prepend_path_if_exists "$XDG_DATA_HOME/node/bin"
[[ -v commands[pnpm] ]] && export PNPM_HOME="$XDG_DATA_HOME/pnpm"
prepend_path_if_exists "$PNPM_HOME"

# bun
source_if_exists "$HOME/.bun/_bun"
prepend_path_if_exists "$HOME/.bun/bin"

# alias for accessing the docker host as a container
[[ -v commands[docker] ]] && alias docker-host='docker run -it --rm --privileged --pid=host justincormack/nsenter1'

# krew
if [[ -v commands[kubectl-krew] ]]; then
  export KREW_ROOT="$XDG_DATA_HOME/krew"
  path=("$KREW_ROOT/bin" $path)
fi

# gcloud
if [[ -s $XDG_DATA_HOME/google-cloud-sdk ]]; then
  export GCLOUD_SDK_PATH="$XDG_DATA_HOME/google-cloud-sdk"
  source_if_exists "$GCLOUD_SDK_PATH/path.zsh.inc"
  source_if_exists "$GCLOUD_SDK_PATH/completion.zsh.inc"
  export USE_GKE_GCLOUD_AUTH_PLUGIN='True'
fi

# time aliases
alias ber='TZ=Europe/Berlin date'
alias nyc='TZ=America/New_York date'
alias sfo='TZ=America/Los_Angeles date'
alias utc='TZ=Etc/UTC date'

# theme for faq syntax highlighting
export FAQ_STYLE='github'

# prefer my own bin over everything else
prepend_path_if_exists "$HOME/.local/bin"
