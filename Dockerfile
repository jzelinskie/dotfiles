FROM alpine:edge
LABEL maintainer "Jimmy Zelinskie <jimmyzelinskie+git@gmail.com>"

RUN \
  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
  apk upgrade --no-cache && \
  apk add --no-cache \
  # System \
  ca-certificates \
  man-pages \
  sudo sudo-doc \
  openssh openssh-doc \
  zig \
  zsh zsh-doc \
  # Tools \
  bat \
  binwalk \
  cloc cloc-doc \
  curl curl-doc \
  exa \
  gdb gdb-doc \
  graphviz graphviz-doc \
  imagemagick imagemagick-doc \
  jq jq-doc \
  mysql-client \
  nmap nmap-doc \
  p7zip p7zip-doc \
  percona-toolkit percona-toolkit-doc \
  postgresql \
  python2 python3 \
  ripgrep \
  rsync \
  skim skim-doc skim-zsh-completion \
  skopeo \
  speedtest-cli \
  sqlite sqlite-doc \
  sshuttle \
  terraform \
  tmux tmux-doc \
  xz xz-doc \
  youtube-dl youtube-dl-doc youtube-dl-zsh-completion \
  zstd zstd-doc \
  # Version Control \ 
  git git-doc \
  hub hub-doc \
  mercurial mercurial-doc \
  # Editors \
  neovim neovim-doc neovim-lang

SHELL ["/bin/zsh", "-c"]
RUN \
  echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  adduser -D -G wheel jzelinskie
USER jzelinskie
WORKDIR /home/jzelinskie
ENV XDG_CONFIG_HOME=/home/jzelinskie/.config XDG_DATA_HOME=/home/jzelinskie/.local/share

COPY --chown=jzelinskie:wheel . $XDG_CONFIG_HOME/dotfiles/

RUN \
  # Install dotfiles \
  DOTFILES_NONINTERACTIVE=1 $XDG_CONFIG_HOME/dotfiles/install.zsh && \
  # Rewrite clones to use https, instead of ssh \
  sed -i '/github.com/d' $HOME/.gitconfig && \
  git config --global url."https://github.com/".insteadOf git@github.com: && \
  git config --global url."https://".insteadOf git:// && \
  # Generate zsh config \
  git clone "git@github.com:tarjoilija/zgen.git" "$XDG_DATA_HOME/zgen" && \
  source $HOME/.zshrc && \
  # Install nvim plugins \
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

ENTRYPOINT [ "zsh" ]
