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
	cmake

	# git
	git
	github-cli
	git-delta

	# cli
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
	luarocks
	rustup
	npm
	pnpm

	# media
	pipewire
	pipewire-audio
	pipewire-pulse
	pipewire-jack
	wireplumber
	playerctl
	brightnessctl

	# notifications
	libnotify

	# clipboard
	wl-clipboard

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
	qt6-multimedia-ffmpeg
	dolphin

	# apps
	qutebrowser
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

install_rust() {
	rustup toolchain install stable
	rustup toolchain install nightly
	rustup default stable
	cargo install cargo-update
}

install_wrapper yay install_yay
install_wrapper rustup install_rust
