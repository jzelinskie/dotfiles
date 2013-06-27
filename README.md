# .dotfiles/

## install

* Clone this directory to $HOME/.dotfiles
* `zsh install.zsh` will create symlinks in $HOME/.file to $HOME/.dotfiles/file


## .zshrc

I use [prezto](https://github.com/sorin-ionescu/prezto) as a zsh framework. If you've never heard of it, it's like a nicer [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh). To install, first install your dotfiles, then just `git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"`. Finally, set zsh as the default shell.

## .vim

I use [vundle](https://github.com/gmarik/vundle) to install all my plugins for vim. If you've never heard of it, it's like a nicer [pathogen](https://github.com/tpope/vim-pathogen). To install, first install your dotfiles, then `mkdir -p $HOME/.vim`. Next, `git clone https://github.com/gmarik/vundle $HOME/.vim/bundle/vundle`. Finally, install all the plugins by running `vim +BundleInstall`
