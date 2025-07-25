install_deps() {
	sudo add-apt-repository -y ppa:fish-shell/release-4
	sudo apt -y -q update

	deps=(
		fish
		stow
		zoxide
		fd-find
		ripgrep
		gh
		fzf
		gnome-tweaks
		gtk2-engines-murrine
		pass
		tldr
		just
	)

	sudo apt -y -q install ${deps[@]}
}

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

install_nvim() {
	curl -L# https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz | tar -xz -C $DOWNLOADS
	ln -sf $DOWNLOADS/nvim-linux-x86_64/bin/nvim $HOME/.local/bin/nvim
}

install_tmux() {
	# libevent
	sudo apt install -y libevent-dev libncurses-dev bison

	# tmux
	curl -L# https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz | tar -xz -C $DOWNLOADS
	cd $DOWNLOADS/tmux-3.4
	./configure && make
	sudo make install
	cd $DOTFILES

	# tpm
	local tpm_dir=$HOME/.tmux/plugins/tpm
	if [ ! -d "$tpm_dir" ]; then
		git clone https://github.com/tmux-plugins/tpm $tpm_dir
	fi
}

install_fd() {
	ln -s $(which fdfind) $HOME/.local/bin/fd
}

install_n() {
	export N_PREFIX=$HOME/.n
	export PATH=$N_PREFIX/bin:$PATH
	curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n | bash -s lts
	npm install -g n
}

install_eza() {
	sudo apt update -y
	sudo apt install -y gpg

	sudo mkdir -p /etc/apt/keyrings
	wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
	echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
	sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
	sudo apt update -y
	sudo apt install -y eza
}

install_luarocks() {
	# Install prerequisites
	sudo apt install build-essential libreadline-dev unzip

	# Install Lua 5.4.7
	cd $DOWNLOADS
	curl -L -R -O https://www.lua.org/ftp/lua-5.4.7.tar.gz
	tar zxf lua-5.4.7.tar.gz
	cd lua-5.4.7
	make linux test
	sudo make install

	# Install LuaRocks 3.11.1
	cd $DOWNLOADS
	curl -L -R -O http://luarocks.github.io/luarocks/releases/luarocks-3.11.1.tar.gz
	tar zxf luarocks-3.11.1.tar.gz
	cd luarocks-3.11.1
	./configure --with-lua-include=/usr/local/include
	make
	sudo make install
}

install_deno() {
	npm install -g deno
}

install_cargo_deps() {
	cargo install bat skim mcfly sd --locked
}

# apt deps
install_deps
echo ""

# essentials
install_wrapper nvim install_nvim
install_wrapper tmux install_tmux
install_wrapper starship install_starship
install_wrapper n install_n
install_wrapper deno install_deno
install_wrapper eza install_eza
install_wrapper fdfind install_fd
install_wrapper luarocks install_luarocks

# things that i currently install through cargo
install_wrapper rustup install_rustup
install_cargo_deps
