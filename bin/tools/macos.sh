# source $DOTFILES/bin/fonts.sh

install_brew() {
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew update --force

	# Taken from homebrew's install.sh script
	UNAME_MACHINE="$(/usr/bin/uname -m)"

	if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
		# On ARM macOS, this script installs to /opt/homebrew only
		HOMEBREW_PREFIX="/opt/homebrew"
	else
		# On Intel macOS, this script installs to /usr/local only
		HOMEBREW_PREFIX="/usr/local"
	fi

	eval "\$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
}

install_deps() {
	deps=(
		fish
		tmux
		stow
		zoxide
		fd
		eza
		ripgrep
		gh
		fzf
		sk
		pass
		tldr
		starship
		rustup
		bat
		n
		deno
		just
		sd
		ffmpeg
		sevenzip
		jq
		poppler
		resvg
		imagemagick
		font-symbols-only-nerd-font
		yazi
		docker
		font-iosevka-nerd-font
	)

	brew install ${deps[@]}
}

install_nvim() {
	curl -L# https://github.com/neovim/neovim/releases/download/stable/nvim-macos.tar.gz --output $DOWNLOADS/nvim-macos.tar.gz
	cd $DOWNLOADS
	xattr -c ./nvim-macos.tar.gz
	tar xzf nvim-macos.tar.gz
	cd $HOME
	ln -sf $DOWNLOADS/nvim-macos/bin/nvim $HOME/.local/bin/nvim
}

install_wrapper brew install_brew
install_deps
echo ""
install_wrapper nvim install_nvim
