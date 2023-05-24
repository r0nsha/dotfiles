#!/usr/bin/env bash
#
# bootstrap installs things.

cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

set -e

echo ""

info() {
	printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user() {
	printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success() {
	printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
	printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
	echo ''
	exit
}

os() {
	uname -s
}

link_file() {
	local src=$1 dst=$2

	local overwrite=
	local backup=
	local skip=
	local action=

	if [ -f "$dst" ] || [ -d "$dst" ] || [ -L "$dst" ]; then

		if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then

			# ignoring exit 1 from readlink in case where file already exists
			# shellcheck disable=SC2155
			local currentSrc="$(readlink $dst)"

			if [ "$currentSrc" == "$src" ]; then

				skip=true

			else

				user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
				read -n 1 action </dev/tty

				case "$action" in
				o)
					overwrite=true
					;;
				O)
					overwrite_all=true
					;;
				b)
					backup=true
					;;
				B)
					backup_all=true
					;;
				s)
					skip=true
					;;
				S)
					skip_all=true
					;;
				*) ;;
				esac

			fi

		fi

		overwrite=${overwrite:-$overwrite_all}
		backup=${backup:-$backup_all}
		skip=${skip:-$skip_all}

		if [ "$overwrite" == "true" ]; then
			rm -rf "$dst"
			success "removed $dst"
		fi

		if [ "$backup" == "true" ]; then
			mv "$dst" "${dst}.backup"
			success "moved $dst to ${dst}.backup"
		fi

		if [ "$skip" == "true" ]; then
			success "skipped $src"
		fi
	fi

	if [ "$skip" != "true" ]; then # "false" or empty
		ln -s "$1" "$2"
		success "linked $1 to $2"
	fi
}

init_git_submodules() {
	info "updating submodules"

	git submodule init
	git submodule update --init --recursive

	success "updated git submodules"
}

install_dotfiles() {
	info 'installing dotfiles'

	local overwrite_all=false backup_all=false skip_all=false

	find -H "$DOTFILES" -maxdepth 2 -name 'links.prop' -not -path '*.git*' | while read linkfile; do
		cat "$linkfile" | while read line; do
			local src dst dir
			src=$(eval echo "$line" | cut -d '=' -f 1)
			dst=$(eval echo "$line" | cut -d '=' -f 2)
			dir=$(dirname $dst)

			mkdir -p "$dir"
			link_file "$src" "$dst"
		done
	done
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

default_shell() {
	fish_bin=$(which fish)

	echo ""

	if [ "$SHELL" != "$fish_bin" ]; then
		info "changing your default shell to fish"
		echo fish_bin | sudo tee -a /etc/shells
		chsh -s fish_bin
		success "your default shell is now fish. yay!"
	else
		success "your default shell is already fish, skipping"
	fi
}

init_git_submodules
install_dotfiles
create_env_file
install_deps
default_shell

echo ""
echo ""
success 'All installed!'
