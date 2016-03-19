# jzelinskie's dotfiles

I primarily use darwin, but sometimes I use linux and cygwin.
These *should* work on all three platforms.

## install

All the installation does is:

- symlink files like `$HOME/.dotfiles/.$FILE` to `$HOME/.$FILE`
- git clone [prezto](https://github.com/sorin-ionescu/prezto)

```sh
$ git clone git@github.com:jzelinskie/dotfiles.git $HOME/.dotfiles
$ ./$HOME/.dotfiles/install.zsh
```

