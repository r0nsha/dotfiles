# source $DOTFILES/bin/fonts.sh

install_brew() {
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew update --force

	# Taken from homebrew's install.sh script
	UNAME_MACHINE="$(/usr/bin/uname -m)"

	if [[ "${UNAME_MACHINE}" == "arm64" ]]; then
		# On ARM macOS, this script installs to /opt/homebrew only
		HOMEBREW_PREFIX="/opt/homebrew"
	else
		# On Intel macOS, this script installs to /usr/local only
		HOMEBREW_PREFIX="/usr/local"
	fi

	eval "\$(${HOMEBREW_PREFIX}/bin/brew shellenv)"

	echo >>/Users/ron.s/.zprofile
	echo 'eval "$(${HOMEBREW_PREFIX}bin/brew shellenv)"' >>/Users/ron.s/.zprofile
	eval "$(${HOMEBREW_PREFIX}/brew shellenv)"
}

install_deps() {
	deps=(
		fish
		tmux
		stow
		zoxide
		fd
		eza
		ripgrep
		gh
		fzf
		sk
		pass
		tldr
		rustup
		bat
		git-delta
		n
		deno
		just
		sd
		ffmpeg
		sevenzip
		jq
		poppler
		resvg
		imagemagick
		font-symbols-only-nerd-font
		yazi
		docker
		colima
		kitty
		neovim
		font-iosevka-nerd-font
		opencode
		jj
		jjui
		responsively
		mcfly
		gnupg
		pinentry-mac
		n
		go
		nikitabobko/tap/aerospace
	)

	brew install ${deps[@]}
}

install_wrapper brew install_brew
install_deps
echo ""

echo "pinentry-program $(which pinentry-mac)" >>~/.gnupg/gpg-agent.conf
gpg-connect-agent reloadagent /bye
