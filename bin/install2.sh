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
    echo "set -Ux DOTFILES $DOTFILES" >$HOME/.env.fish
    success
fi

step "git"
chmod ug+x $DOTFILES/hooks/*
git submodule init
git submodule update --init --recursive
success

step "wallpapers"
ln -sf $DOTFILES/wallpapers $HOME/Pictures/Wallpapers # link wallpapers
success

# load dconf settings
if exists "dconf"; then
    step "dconf"
    dconf load / <$DOTFILES/dconf/settings.ini
    success
fi

# load gtk theme
if [ "$MACHINE" = "linux" ]; then
    step "gtk theme"
    GTK_THEMES=$LOCAL_SHARE/themes
    GTK_ICONS=$LOCAL_SHARE/icons

    mkdir -p $GTK_THEMES $GTK_ICONS

    sudo $DOTFILES/gtk/Rose-Pine-GTK-Theme/themes/install.sh --dest $GTK_THEMES --name Rose-Pine --theme default --size compact --tweaks black
    cp -r $DOTFILES/gtk/Rose-Pine-GTK-Theme/icons $GTK_ICONS
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
        if echo "$files" | grep -q "$pattern"; then
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

    for url in "${FONT_URLS[@]}"; do
        curl -#L "$url" -o "$DOWNLOADS/$(basename $url)"
    done

    wait

    # printf "%s\n" "${FONT_URLS[@]}" | xargs -P $(nproc) -I {} curl -#Lv {} #-o "$DOWNLOADS/$(basename {})"
    # # printf "%s\n" "${FONT_URLS[@]}" | xargs -P $(nproc) -I {} echo "$DOWNLOADS/$(basename {})"

    # unzip -o "$DOWNLOADS/*.zip" -d $FONTS_DIR >/dev/null

    success
fi

# macos defaults
if [ "$MACHINE" = "darwin" ]; then
    step "setting macos defaults"
    source $DOTFILES/bin/macos_defaults.sh
    success
fi

echo "i installed your things :)"
