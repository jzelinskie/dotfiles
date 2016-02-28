# jzelinskie's dotfiles

I primarily use OSX, but can work on GNU/Linux as well; ideally these should work perfect on both.

## install

```sh
$ git clone git@github.com:jzelinskie/dotfiles.git $HOME/.dotfiles
$ ./$HOME/.dotfiles/install.zsh
```

All installation does is:
- symlink files like `$HOME/.dotfiles/.$FILE` to `$HOME/.$FILE`
- git clone [prezto](https://github.com/sorin-ionescu/prezto)
