source $DOTFILES/bin/shared.sh

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
	info "root access is needed to install dependencies"

	install() {
		info "installing $1"
		brew install -q $1
	}

	deps=(
		fish
		tmux
		zoxide
		fd
		eza
		ripgrep
		gh
		fzf
		bat
		koekeishiya/formulae/yabai
		koekeishiya/formulae/skhd
	)

	for dep in ${deps[@]}; do
		install $dep
	done
}

install_nvim() {
	curl -sL https://github.com/neovim/neovim/releases/download/stable/nvim-macos.tar.gz --output $DOWNLOADS/nvim-macos.tar.gz
	cd $DOWNLOADS
	xattr -c ./nvim-macos.tar.gz
	tar xzf nvim-macos.tar.gz
	cd $HOME
	ln -sf $DOWNLOADS/nvim-macos/bin/nvim $HOME/.local/bin/nvim
}

install_starship() {
	curl -sS https://starship.rs/install.sh | sh
}

install_rustup() {
	curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable
}

install_tmux() {
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

install_n() {
	export N_PREFIX=$HOME/.n
	export PATH=$N_PREFIX/bin:$PATH
	curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts
	npm install -g n
}

install_wrapper brew install_brew
install_deps
echo ""
install_wrapper nvim install_nvim
