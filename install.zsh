#!/bin/zsh

setopt EXTENDED_GLOB

for dotfile in "${ZDOTDIR:-$HOME}"/.dotfiles/(.??*)(.N); do
  if [[ ! -a "${ZDOTDIR:-$HOME}/${dotfile:t}" ]]; then
    ln -s "$dotfile" "${ZDOTDIR:-$HOME}/${dotfile:t}"
  fi
done

if [[ ! -a "${ZDOTDIR:-$HOME}/.zprezto" ]]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi
