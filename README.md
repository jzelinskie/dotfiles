# Jimmy Zelinskie's Dotfiles

I primarily use macOS, but I also use Linux and Cygwin/WSL on Windows.
I strive to make everything work *within reason* across all three platforms.
Configuration requiring non-standard software should also gracefully degrade to something available on all platforms.
I kinda take a [suckless]-style approach to configuration: nothing should be thousands of lines.

[suckless]: https://suckless.org

## Installation

## Toolbox

[I wrote a post] about BYOU (Bring Your Own Userspace).

Basically, you can run my dotfiles in a container and mount your host inside, if you don't want to install anything.

[I wrote a post]: https://jzelinskie.com/posts/toolbox-for-your-dotfiles

## Directly

A simple installation zsh script is provided that inspects the filesystem and prompts the user before making any changes.

Because vim and zsh install all of their plugins on first run, this script just creates symlinks and optionally installs [Homebrew] packages.

[Homebrew]: https://brew.sh

```sh
$ git clone git@github.com:jzelinskie/dotfiles.git ~/.dotfiles
$ zsh ~/.dotfiles/install.zsh
```
