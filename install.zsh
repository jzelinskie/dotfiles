#!/bin/zsh

set -e
setopt EXTENDED_GLOB

# Default values for configurable variables
export INSTALL_DIR=${INSTALL_DIR:-$HOME}
export DOTFILES_DIR=${DOTFILES_DIR:-$HOME/.dotfiles}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$INSTALL_DIR/.config}

# Prompt the user
if [ -z ${DOTFILES_NONINTERACTIVE+x} ]; then
  echo "Installing dotfiles in $DOTFILES_DIR into $INSTALL_DIR"
  echo "You can override these with \$DOTFILES_DIR and \$INSTALL_DIR, respectively"
  echo -n "Continue? "
  read REPLY
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cowardly refusing to link dotfiles"
    exit 1
  fi
fi

# Handle vim first, b/c we need to do extra work to support both vim & neovim.
echo
echo "Linking nvim/vim compatible files..."
mkdir -p $XDG_CONFIG_HOME/nvim
local VIM_LINKS=(
  "$DOTFILES_DIR/.vimrc:$XDG_CONFIG_HOME/nvim/init.vim"
  "$XDG_CONFIG_HOME/nvim/init.vim:$INSTALL_DIR/.vimrc"
  "$XDG_CONFIG_HOME/nvim:$INSTALL_DIR/.vim"
)
for LINK in $VIM_LINKS; do
  local FILE=`echo $LINK | awk -F":" '{print $1}'`
  local TARGET=`echo $LINK | awk -F":" '{print $2}'`
  if [[ ! -a $TARGET ]]; then
    print -P -- "  %F{002}Linking file:%f $FILE => $TARGET"
    ln -s $FILE $TARGET
  else
    print -P -- "  %F{011}Link already exists:%f $FILE => $TARGET"
  fi
done

# Symlink the rest of the dotfiles
echo
echo "Linking the rest of the dotfiles..."
for FILE in $DOTFILES_DIR/(.??*)(.N); do
  local TARGET=$INSTALL_DIR/${FILE:t}
  if [[ ! -a $INSTALL_DIR/${FILE:t} ]]; then
    print -P -- "  %F{002}Linking file:%f $FILE => $TARGET"
    ln -s $FILE $INSTALL_DIR/${FILE:t}
  else
    print -P -- "  %F{011}Link already exists:%f $FILE => $TARGET"
  fi
done

# Homebrew installation
if [ -z ${DOTFILES_NONINTERACTIVE+x} ] && which brew > /dev/null; then
  echo
  echo "Homebrew installation detected."
  echo "Do you want to install Brewfile contents?"
  echo -n "Continue? "
  read REPLY
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cowardly refusing to install brew packagfes"
    exit 1
  else
    cat $DOTFILES_DIR/Brewfile | xargs brew install
  fi
fi
