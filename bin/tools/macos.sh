source $DOTFILES/bin/utils.sh

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
	install() {
		info "installing $1"
		brew install -q $1
	}

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
		koekeishiya/formulae/yabai
		koekeishiya/formulae/skhd
		pass
		tldr
		starship
		rustup
		yazi
		bat
		n
		deno
		navi
		atuin
	)

	for dep in ${deps[@]}; do
		install $dep
	done
}

install_nvim() {
	curl -L# https://github.com/neovim/neovim/releases/download/stable/nvim-macos.tar.gz --output $DOWNLOADS/nvim-macos.tar.gz
	cd $DOWNLOADS
	xattr -c ./nvim-macos.tar.gz
	tar xzf nvim-macos.tar.gz
	cd $HOME
	ln -sf $DOWNLOADS/nvim-macos/bin/nvim $HOME/.local/bin/nvim
}

install_navi() {
	navi repo add denisidoro/cheats
	navi repo add denisidoro/navi-tldr-pages
}

install_wrapper brew install_brew
install_deps
echo ""
install_wrapper nvim install_nvim
install_wrapper navi install_navi
