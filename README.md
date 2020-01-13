# jzelinskie's dotfiles

I primarily use darwin, but sometimes I use linux and cygwin.
These *should* work on all three platforms.

## installation

## toolbox

[I wrote a post] about BYOU (Bring Your Own Userspace).
Basically, you can run my dotfiles in a container and mount your host inside, if you don't want to install anything.

[I wrote a post]: https://medium.com/@jzelinskie/a-toolbox-for-your-dotfiles-acd4fd2851ac

## directly

All the installation script does is symlink files like `$HOME/.dotfiles/.$FILE` to `$HOME/.$FILE`.
Plugins used for vim and zsh should install themselves (thanks to vim-plug and zplug).

```sh
$ git clone git@github.com:jzelinskie/dotfiles.git $HOME/.dotfiles
$ ./$HOME/.dotfiles/install.zsh
```

