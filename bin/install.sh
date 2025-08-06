#!/usr/bin/env bash
#
# install.sh installs my things.

set -euo pipefail

script_dir=$(dirname "$0")
DOTFILES=$(realpath -s $script_dir/..)
LOCAL_BIN="$HOME/.local/bin"
LOCAL_OPT="$HOME/.local/opt"
LOCAL_SHARE="${XDG_DATA_HOME:-$HOME/.local/share}"
DEV="$HOME/dev"
DOWNLOADS="${XDG_DOWNLOAD_DIR:-$HOME/downloads}"
PICTURES="${XDG_PICTURES_DIR:-$HOME/pictures}"

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

mkdir -p $LOCAL_BIN $LOCAL_OPT $LOCAL_SHARE $DEV $DOWNLOADS $PICTURES

LOCAL_ENV=$HOME/.env.fish
if [ ! -f "$LOCAL_ENV" ]; then
    step "creating local env file"
    echo "set -Ux DOTFILES $DOTFILES" >$LOCAL_ENV
    info "created $LOCAL_ENV"
    success
fi

step "git"
git submodule init
git submodule update --init --recursive
success

step "backgrounds"
ln -sfv $DOTFILES/backgrounds $PICTURES
success

# make scripts executable
step "scripts"
chmod -v ug+x $DOTFILES/scripts/*
chmod -v ug+x $DOTFILES/i3blocks/scripts/*
find $DOTFILES/rofi -type f -name "rofi-*" -exec chmod -v ug+x {} \;
success

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
        chsh -s $fish_bin
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

# build bat's cache
bat cache --build

echo "i installed your things :)"
