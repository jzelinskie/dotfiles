#!/bin/zsh

setopt EXTENDED_GLOB

for dotfile in "${ZDOTDIR:-$HOME}"/.dotfiles/(.??*)(.N); do
  if [[ ! -a "${ZDOTDIR:-$HOME}/${dotfile:t}" ]]; then
    ln -s "$dotfile" "${ZDOTDIR:-$HOME}/${dotfile:t}"
  fi
done
