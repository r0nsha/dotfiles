source $DOTFILES/bin/shared.sh

install_deps() {
	info "root access is needed to install dependencies"

	install() {
		info "installing $1"
		sudo apt -y -qq install $1
	}

	sudo add-apt-repository -y ppa:fish-shell/release-4
	sudo apt -y -qq update

	deps=(
		stow
		zoxide
		fd-find
		ripgrep
		gh
		fzf
		bat
		gnome-tweaks
		gtk2-engines-murrine
	)

	for dep in ${deps[@]}; do
		install $dep
	done
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

	# tmp
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

install_fd() {
	ln -s $(which fdfind) $HOME/.local/bin/fd
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

install_deps
echo ""
install_wrapper nvim install_nvim
install_wrapper tmux install_tmux
install_wrapper fdfind install_fd
install_wrapper eza install_eza
install_wrapper luarocks install_luarocks
