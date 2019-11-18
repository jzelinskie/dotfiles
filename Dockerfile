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
		py3-sshuttle \
		python python3 \
		ripgrep \
		rsync \
		skim skim-doc skim-zsh-completion \
		skopeo \
		speedtest-cli \
		sqlite sqlite-doc \
		terraform \
		tmux tmux-doc \
		upx upx-doc \
		xz xz-doc \
		youtube-dl youtube-dl-doc youtube-dl-zsh-completion \
		zstd zstd-doc \
		# Version Control \ 
		git git-doc \
		hub hub-doc \
		mercurial mercurial-doc \
		# Editors \
		neovim neovim-doc neovim-lang

RUN \
	echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
	adduser -D -G wheel jimmy
USER jimmy

RUN \
	# Rewrite clones to use https, instead of ssh \
	git config --global url."https://github.com/".insteadOf git@github.com: && \
	git config --global url."https://".insteadOf git:// && \
	# Install dotfiles \
	git clone "git@github.com:jzelinskie/dotfiles.git" "$HOME/.dotfiles" && \
	DOTFILES_NONINTERACTIVE=1 zsh -c "$HOME/.dotfiles/install.zsh" && \
	git clone "git@github.com:tarjoilija/zgen.git" "$HOME/.zgen" && \
	zsh -c "source $HOME/.zshrc" && \
	nvim +PackInstall +qall
