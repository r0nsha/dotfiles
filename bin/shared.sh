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

DOWNLOADS=$HOME/downloads

install_wrapper() {
	if ! command -v $1 &>/dev/null; then
		info "installing $1"
		$2
		success "installed $1"
	else
		success "$1 is already installed, skipping"
	fi
}
