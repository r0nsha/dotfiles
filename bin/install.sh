#!/usr/bin/env bash
#
# install.sh installs my things.

set -euo pipefail

script_dir=$(dirname "$0")
DOTFILES=$(realpath -s $script_dir/..)
ROOT_BIN="/usr/local/bin"
LOCAL_BIN="$HOME/.local/bin"
LOCAL_SHARE="${XDG_DATA_HOME:-$HOME/.local/share}"
DOWNLOADS="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"

cat $DOTFILES/bin/pepe.txt

source $DOTFILES/bin/utils.sh

case "$(uname)" in
Linux) MACHINE="linux" ;;
Darwin) MACHINE="darwin" ;;
*) MACHINE="unknown" ;;
esac

if [ "$MACHINE" = "unknown" ]; then
    error "unsupported operating system: $(uname)"
fi

cd $DOTFILES

mkdir -p $LOCAL_BIN $LOCAL_SHARE $DOWNLOADS

LOCAL_ENV=$HOME/.env.fish
if [ ! -f "$LOCAL_ENV" ]; then
    step "creating local env file"
    echo "set -Ux DOTFILES $DOTFILES" >$LOCAL_ENV
    info "created $LOCAL_ENV"
    success
fi

step "git"
chmod -v ug+x $DOTFILES/hooks/*
git submodule init
git submodule update --init --recursive
success

step "wallpapers"
ln -sfv $DOTFILES/wallpapers $HOME/Pictures/Wallpapers # link wallpapers
success

# load dconf settings
if exists "dconf"; then
    step "dconf"
    dconf load / <$DOTFILES/dconf/settings.ini
    info "loaded dconf settings"
    success
fi

# install fonts
case "$MACHINE" in
linux)
    FONTS_DIR=$LOCAL_SHARE/fonts
    ;;
darwin)
    FONTS_DIR=$HOME/Library/Fonts
    ;;
esac

mkdir -p $FONTS_DIR
FONTS_BASE_URL=https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0

not_installed_fonts() {
    local files=$(ls $FONTS_DIR)
    local not_installed=()
    for font in "$@"; do
        local pattern=$(echo "$font" | tr -d ' ')"NerdFont"
        if ! echo "$files" | grep -q "$pattern"; then
            not_installed+=("$font")
        fi
    done
    echo "${not_installed[@]}"
}

FONTS_TO_INSTALL=("Iosevka" "IosevkaTerm")
FONTS_TO_INSTALL=$(not_installed_fonts $FONTS_TO_INSTALL)
if [ -n "$FONTS_TO_INSTALL" ]; then
    step "installing fonts"

    FONT_URLS=()
    for f in "${FONTS_TO_INSTALL[@]}"; do
        FONT_URLS+=("$FONTS_BASE_URL/${f}.zip")
    done

    info "downloading fonts..."
    wget -q -nc --show-progress -P $DOWNLOADS ${FONT_URLS[@]}

    FONT_FILES=()
    for f in "${FONTS_TO_INSTALL[@]}"; do
        FONT_FILES+=("$DOWNLOADS/${f}.zip")
    done

    info "extracting fonts..."
    for f in "${FONT_FILES[@]}"; do
        unzip -oq -d $FONTS_DIR $f "*.ttf" &
    done
    wait

    success
fi

# make scripts executable
chmod -v ug+x $DOTFILES/rofi/scripts/*
chmod -v ug+x $DOTFILES/i3blocks/scripts/*

# install tools
step "tools"
source $DOTFILES/bin/tools.sh
success

# stow dotfiles
step "stow"
cd $DOTFILES
stow .
info "stowed dotfiles"
success

# default shell
if exists "fish"; then
    if [ "$(basename "$SHELL")" != "fish" ]; then
        step "default shell"
        fish_bin=$(which fish)
        echo $fish_bin | sudo tee -a /etc/shells
        sudo chsh -s $fish_bin
        success
    fi
fi

# macos defaults
if [ "$MACHINE" = "darwin" ]; then
    step "setting macos defaults"
    source $DOTFILES/bin/macos_defaults.sh
    success
fi

echo "i installed your things :)"
