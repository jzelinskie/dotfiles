# jzelinskie's dotfiles

I primarily use darwin, but sometimes I use linux and cygwin.
These *should* work on all three platforms.

## installation

All the installation script does is symlink files like `$HOME/.dotfiles/.$FILE` to `$HOME/.$FILE`.
Plugins used for vim and zsh should install themselves (thanks to vim-plug and zplug).

```sh
$ git clone git@github.com:jzelinskie/dotfiles.git $HOME/.dotfiles
$ ./$HOME/.dotfiles/install.zsh
```

