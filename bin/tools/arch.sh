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
	iwd

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
	bottom
	jq
	imagemagick
	ffmpeg
	xdotool
	wtype
	cliphist

	# media
	pipewire
	pipewire-audio
	pipewire-pulse
	pipewire-jack
	wireplumber
	playerctl
	brightnessctl
	bluez
	bluez-utils
	pamixer

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
	ttf-iosevkatermslab-nerd

	# nvidia
	nvidia
	nvidia-utils
	lib32-nvidia-utils
	egl-wayland

	# desktop
	hyprland
	hyprlock
	hypridle
	hyprpicker
	hyprpolkitagent
	xdg-desktop-portal
	xdg-desktop-portal-hyprland
	xdg-desktop-portal-gtk
	qt5-wayland
	qt6-wayland
	qt6-multimedia-ffmpeg
	swww
	waybar
	ly
	gamemode
	lib32-gamemode
	udiskie

	# rofi
	rofi-wayland
	rofimoji
	rofi-calc

	# apps
	qutebrowser
	steam
	dolphin
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

yay_deps=(
	wired
	hyprprop-git
	vesktop
	bzmenu
	iwmenu
)

yay -S --noconfirm ${yay_deps[@]}

# ly
sudo systemctl enable ly.service
sudo systemctl disable getty@tty2.service

# groups
sudo gpasswd -a $USER gamemode
sudo gpasswd -a $USER network

# bluetooth
sudo systemctl enable --now bluetooth.service
