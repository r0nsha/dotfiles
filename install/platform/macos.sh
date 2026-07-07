# source $DOTFILES/install/fonts.sh

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

    echo >>$HOME/.zprofile
    echo 'eval "$(${HOMEBREW_PREFIX}bin/brew shellenv)"' >>$HOME/.zprofile
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
        tealdeer
        rustup
        bat
        git
        git-delta
        n
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
        ghostty
        entr
        bob             # neovim version manager
        tree-sitter-cli # needed to cache treesitter parsers
        font-iosevka-nerd-font
        opencode
        jj
        responsively
        gnupg2
        pass
        pass-git-helper
        gopass
        pinentry-mac
        n
        go
        nikitabobko/tap/aerospace
        fontforge
        firefox
        watchman
        aerc
        w3m
        dante
        senpai
        localsend
    )

    brew install ${deps[@]}
}

install_wrapper brew install_brew
install_deps
echo ""

if exists "qutebrowser"; then
    rm -rf "$HOME/.qutebrowser"
    ln -sv "$DOTFILES/qutebrowser" "$HOME/.qutebrowser"
fi
