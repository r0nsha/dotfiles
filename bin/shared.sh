log_message() {
	local color="$1"
	local prefix="$2"
	local message="$3"
	local nc='\033[0m'
	echo -e "\r[${color}${prefix}${nc}] ${message}"
}

info() {
	log_message '\033[0;34m' 'i' "$*"
}

running() {
	log_message '\033[0;33m' '~' "$*"
}

success() {
	log_message '\033[0;32m' '+' "$*"
}

fail() {
	log_message '\033[0;31m' '!' "$*"
	echo ""
	exit 1
}

DOWNLOADS=$HOME/Downloads

install_wrapper() {
	if ! command -v $1 &>/dev/null; then
		running "installing $1"
		$2
		success "installed $1"
	else
		info "$1 is already installed, skipping"
	fi
}
