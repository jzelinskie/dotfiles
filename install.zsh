#!/usr/bin/env zsh
set -e
setopt EXTENDED_GLOB

# Find the current directory
local DOTFILES_DIR="$(cd $(dirname ${BASH_SOURCE[0]-$0}) && pwd)"

# Default values for configurable variables
local XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
local INSTALL_DIR=${INSTALL_DIR:-$HOME}

# Prompt the user
if [ -z ${DOTFILES_NONINTERACTIVE+x} ]; then
  echo "Installing dotfiles in $DOTFILES_DIR into $XDG_CONFIG_HOME and $INSTALL_DIR"
  echo "You can override these with \$XDG_CONFIG_HOME and \$INSTALL_DIR, respectively"
  echo -n "Continue? "
  read REPLY
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cowardly refusing to link dotfiles"
    exit 1
  fi
fi

# Install everything that belongs in $XDG_CONFIG_HOME
echo
echo "Linking XDG_CONFIG_HOME configurations..."
local XDG_LINKS=(
  "$DOTFILES_DIR/init.lua:$XDG_CONFIG_HOME/nvim/init.lua"
  "$DOTFILES_DIR/kitty.conf:$XDG_CONFIG_HOME/kitty/kitty.conf"
  "$DOTFILES_DIR/helix:$XDG_CONFIG_HOME"
)
for LINK in $XDG_LINKS; do
  local FILE=`echo $LINK | awk -F":" '{print $1}'`
  local TARGET=`echo $LINK | awk -F":" '{print $2}'`
  if [[ ! -a $TARGET ]]; then
    mkdir -p $(dirname $TARGET)
    print -P -- "  %F{002}Linking file:%f $FILE => $TARGET"
    ln -s $FILE $TARGET
  else
    print -P -- "  %F{011}Link already exists:%f $FILE => $TARGET"
  fi
done

# Install everything that belongs in $HOME
echo
echo "Linking the dotfiles..."
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
    echo "Cowardly refusing to install brew packages"
    exit 1
  else
    brew bundle install $DOTFILES_DIR/Brewfile
  fi
fi
