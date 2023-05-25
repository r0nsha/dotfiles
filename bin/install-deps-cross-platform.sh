info() {
	printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success() {
	printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

install_wrapper() {
	if ! command -v $1 &>/dev/null; then
		info "installing $1"
		$2
		success "installed $1"
	else
		success "$1 is already installed, skipping"
	fi
}

DOWNLOADS=$HOME/downloads
mkdir -p $HOME/downloads
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share

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

install_wrapper starship install_starship
install_wrapper rustup install_rustup
install_wrapper tmux install_tmux
install_wrapper n install_n
