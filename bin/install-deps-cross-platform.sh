source $DOTFILES/bin/shared.sh

install_starship() {
	curl -sS https://starship.rs/install.sh | sh
}

install_rustup() {
	curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable

	# Needed for cargo-update on Ubuntu
	if [ "$MACHINE" = "linux" ]; then
		sudo apt install -y -qq libssl-dev
	fi

	cargo install cargo-update
}

install_sk() {
	cargo install skim --locked
}

install_bat() {
	cargo install bat --locked
}

install_n() {
	export N_PREFIX=$HOME/.n
	export PATH=$N_PREFIX/bin:$PATH
	curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts
	npm install -g n
}

install_yazi() {
	cargo install yazi --locked
}

install_just() {
	cargo install just --locked
}

install_deno() {
	npm install -g deno
}

install_wrapper starship install_starship
install_wrapper rustup install_rustup
install_wrapper sk install_sk
install_wrapper bat install_bat
install_wrapper n install_n
install_wrapper yazi install_yazi
install_wrapper just install_just
install_wrapper deno install_deno
