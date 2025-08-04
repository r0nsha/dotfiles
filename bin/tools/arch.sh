pacman_deps=(
	# core
	coreutils
	util-linux
	stow
	man-db
	man-pages
	texinfo
	sudo
	base-devel

	# git
	git
	github-cli
	git-delta

	# tools
	zoxide
	eza
	bat
	fd
	ripgrep
	sd
	fzf
	skim
	pass
	tealdeer
	just
	cmake
	libnotify
	pipewire-jack
	luarocks
	rustup
	pnpm

	# python
	python
	python-pip
	python-adblock

	# terminal
	fish
	tmux
	nvim
	starship
	mcfly

	# fonts
	noto-fonts
	noto-fonts-emoji
	ttf-iosevka-nerd
	ttf-iosevkaterm-nerd

	# desktop
	hyprland
	rofimoji

	# apps
	qutebrowser

	#playerctl
	#rofi
	#udiskie
)

sudo pacman -Syu --noconfirm ${pacman_deps[@]}

# Install TPM
tpm_dir=$HOME/.tmux/plugins/tpm
if [ ! -d "$tpm_dir" ]; then
	git clone https://github.com/tmux-plugins/tpm $tpm_dir
fi

install_yay() {
	cd $DOWNLOADS
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si --noconfirm
	yay -Y --gendb
	yay -Syu --noconfirm --devel --save
}

install_wrapper yay install_yay

# Install rust stuff
rustup toolchain install stable
rustup toolchain install nightly
rustup default stable
cargo install cargo-update
