source $DOTFILES/bin/shared.sh

install_deps() {
	info "root access is needed to install dependencies"

	install() {
		info "installing $1"
		sudo apt -y -qq install $1
	}

	sudo apt -y -qq update

	deps=(
		fish
		tmux
		zoxide
		fd-find
		exa
		ripgrep
		gh
		fzf
		bat
	)

	for dep in ${deps[@]}; do
		install $dep
	done
}

install_nvim() {
	curl -sL https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz | tar -xz -C $DOWNLOADS
	ln -sf $DOWNLOADS/nvim-linux64/bin/nvim $HOME/.local/bin/nvim
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

install_deps
echo ""
install_wrapper nvim install_nvim
