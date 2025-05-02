#!/usr/bin/env bash
#
# bootstrap.sh installs my things.

set -e

cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

source $DOTFILES/bin/shared.sh
source $DOTFILES/bin/detect.sh

# init git things
running "doing git things..."
chmod ug+x $DOTFILES/hooks/*
git submodule init
git submodule update --init --recursive
success "did all git things"

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
