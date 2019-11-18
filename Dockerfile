FROM alpine:edge
LABEL maintainer "Jimmy Zelinskie <jimmyzelinskie+git@gmail.com>"

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	apk upgrade --no-cache && \
	apk add --no-cache \
		# System \
		ca-certificates \
		man-pages \
		# Shell \
		bat \
		exa \
		openssh openssh-doc \
		ripgrep \
		tmux tmux-doc \
		zsh zsh-doc \
		# Version Control \ 
		git git-doc \
		mercurial mercurial-doc \
		# Editors \
		neovim neovim-doc neovim-lang

RUN adduser -D jimmy
USER jimmy

RUN \
	# Rewrite clones to use https, instead of ssh \
	git config --global url."https://github.com/".insteadOf git@github.com: && \
	git config --global url."https://".insteadOf git:// && \
  # Install dotfiles \
	git clone "git@github.com:jzelinskie/dotfiles.git" "$HOME/.dotfiles" && \
	DOTFILES_NONINTERACTIVE=1 zsh -c "$HOME/.dotfiles/install.zsh" && \
	git clone "git@github.com:tarjoilija/zgen.git" "$HOME/.zgen" && \
	zsh -c "source $HOME/.zshrc"
