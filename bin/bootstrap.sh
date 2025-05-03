#!/usr/bin/env bash
#
# bootstrap.sh installs my things.

set -e

cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

source $DOTFILES/bin/shared.sh
source $DOTFILES/bin/detect.sh

mkdir -p $DOWNLOADS
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share

# init git things
running "doing git things..."
chmod ug+x $DOTFILES/hooks/*
git submodule init
git submodule update --init --recursive
success "did all git things"

# chmod scripts
chmod ug+x $DOTFILES/*.sh

echo ""

# create env file
running "creating env file..."
env_file="$HOME/.env.fish"
if test -f "$env_file"; then
	info "$env_file file already exists, skipping"
else
	echo "set -Ux DOTFILES $DOTFILES" >$env_file
	success "created $env_file"
fi

echo ""

# setup wallpapers
running "setting up wallpapers..."
ln -siT $DOTFILES/wallpapers $HOME/Pictures/Wallpapers
success "wallpapers set up"

# Install GTK user theme
if [ "$MACHINE" = "linux" ]; then
	running "installing GTK theme..."
	GTK_THEMES=$HOME/.local/share/themes
	mkdir -p $GTK_THEMES
	sudo bash -c "$DOTFILES/gtk/Kanagawa-GTK-Theme/themes/install.sh --dest $GTK_THEMES --name Kanagawa --theme yellow --size compact --tweaks dragon black float"
	success "installed GTK theme"

	# running "installing GTK icons..."
	# GTK_ICONS=$HOME/.local/share/icons
	# mkdir -p $GTK_ICONS
	# cp -r $DOTFILES/gtk/Kanagawa-GTK-Theme/icons/* $GTK_ICONS/.
	# success "installed GTK icons"
fi

# setup fonts
install_fonts() {
	case "$MACHINE" in
	linux) local fonts=$HOME/.local/share/fonts ;;
	macos) local fonts=/Library/Fonts ;;
	*) ;;
	esac

	mkdir -p $fonts

	local fonts_base_url=https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0
	local font=Iosevka
	local font_term=IosevkaTerm
	local font_zip=$DOWNLOADS/$font.zip
	local font_term_zip=$DOWNLOADS/$font_term.zip

	# Check if fonts are already installed
	if [[ $(ls "$fonts" | grep -c "${font// /}NerdFont") -gt 0 &&
	$(ls "$fonts" | grep -c "${font_term// /}NerdFont") -gt 0 ]]; then
		success "fonts already installed, skipping"
		return
	fi

	running "downloading $font and $font_term from $fonts_base_url..."
	wget -nv -O $font_zip $fonts_base_url/$font.zip &
	wget -nv -O $font_term_zip $fonts_base_url/$font_term.zip &
	wait

	running "installing $font and $font_term in $fonts..."
	unzip -q -o $font_zip '*.ttf' -d $fonts &
	unzip -q -o $font_term_zip '*.ttf' -d $fonts &
	wait

	success "fonts installed"
}

install_fonts

# load dconf settings
if which dconf &>/dev/null; then
	running "loading dconf settings..."
	dconf load / <$DOTFILES/dconf/settings.ini
	success "loaded dconf settings"
fi

# install dependencies
running "installing dependencies..."
source $DOTFILES/bin/install-deps-cross-platform.sh
case "$MACHINE" in
linux) source $DOTFILES/bin/install-deps-linux.sh ;;
macos) source $DOTFILES/bin/install-deps-macos.sh ;;
*) ;;
esac
success "dependencies installed"

echo ""

# stow dotfiles
running "stowing dotfiles..."
cd $DOTFILES
stow .
if [ $? -eq 0 ]; then
	success 'stowed dotfiles, great success!'
else
	error 'stow failed!'
fi

echo ""

# set default shell
running "setting default shell to fish..."
fish_bin=$(command -v fish)

if [ "$SHELL" != "$fish_bin" ]; then
	info "changing your default shell to fish"
	echo $fish_bin | sudo tee -a /etc/shells
	chsh -s $fish_bin
	success "your default shell is now fish. yay"
else
	info "your default shell is already fish, skipping"
fi

echo ""
success 'all installed!'
