#!/usr/bin/env bash
#
# bootstrap.sh installs my things.

cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

set -e

echo ""

source $DOTFILES/bin/shared.sh

init_git_submodules() {
	info "updating submodules"

	git submodule init
	git submodule update --init --recursive

	success "updated git submodules"
}

create_env_file() {
	env_file="$HOME/.env.fish"
	if test -f "$env_file"; then
		success "$env_file file already exists, skipping"
	else
		echo "set -Ux DOTFILES $DOTFILES" >$env_file
		success "created $env_file"
	fi
}

install_deps() {
	source $DOTFILES/bin/install-deps-cross-platform.sh
	case $(os) in
	Linux)
		source $DOTFILES/bin/install-deps-linux.sh
		;;
	Darwin)
		source $DOTFILES/bin/install-deps-macos.sh
		;;
	*) ;;
	esac
}

stow_dotfiles() {
	info 'stowing dotfiles...'
	cd $DOTFILES
	stow .
	if [ $? -eq 0 ]; then
		success 'stowed dotfiles, great success!'
	else
		error 'stow failed!'
	fi
}

set_default_shell() {
	fish_bin=$(command -v fish)

	echo ""

	if [ "$SHELL" != "$fish_bin" ]; then
		info "changing your default shell to fish"
		echo $fish_bin | sudo tee -a /etc/shells
		chsh -s $fish_bin
		success "your default shell is now fish. yay!"
	else
		success "your default shell is already fish, skipping"
	fi
}

init_git_submodules
create_env_file
install_deps
stow_dotfiles
set_default_shell

echo ""
echo ""
success 'All installed!'
