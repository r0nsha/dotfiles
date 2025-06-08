#!/usr/bin/env bash
#
# bootstrap.sh installs my things.

set -e

cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

# chmod scripts
chmod ug+x $DOTFILES/**/*.sh

source $DOTFILES/bin/shared.sh
source $DOTFILES/bin/detect.sh

mkdir -p $DOWNLOADS
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share

source $DOTFILES/bin/bootstrap/git_submodules.sh
echo ""

source $DOTFILES/bin/bootstrap/env.sh
echo ""

# setup wallpapers
running "setting up wallpapers..."
ln -si $DOTFILES/wallpapers $HOME/Pictures/Wallpapers
success "wallpapers set up"

source $DOTFILES/bin/bootstrap/gtk.sh
echo ""

source $DOTFILES/bin/bootstrap/fonts.sh
echo ""

source $DOTFILES/bin/bootstrap/dconf.sh
echo ""

# install tools
running "installing tools..."
source $DOTFILES/bin/install-deps-cross-platform.sh
case "$MACHINE" in
linux) source $DOTFILES/bin/install-deps-linux.sh ;;
macos) source $DOTFILES/bin/install-deps-macos.sh ;;
*) ;;
esac
success "tools installed"

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
