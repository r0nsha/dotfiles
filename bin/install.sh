#!/usr/bin/env bash
#
# install.sh installs my things.

set -euo pipefail

script_dir=$(dirname "$0")
DOTFILES=$(realpath "$script_dir/..")
LOCAL_BIN="$HOME/.local/bin"
LOCAL_OPT="$HOME/.local/opt"
LOCAL_SHARE="${XDG_DATA_HOME:-$HOME/.local/share}"
DEV="$HOME/dev"
DOWNLOADS="${XDG_DOWNLOAD_DIR:-$HOME/downloads}"
PICTURES="${XDG_PICTURES_DIR:-$HOME/pictures}"
VIDEOS="${XDG_VIDEOS_DIR:-$HOME/videos}"

cat "$DOTFILES/bin/pepe.txt"

source "$DOTFILES/bin/utils.sh"

case "$(uname)" in
Linux) MACHINE="linux" ;;
Darwin) MACHINE="darwin" ;;
*) MACHINE="unknown" ;;
esac

if [ "$MACHINE" = "unknown" ]; then
    error "unsupported operating system: $(uname)"
fi

cd "$DOTFILES"

mkdir -p "$LOCAL_BIN" "$LOCAL_OPT" "$LOCAL_SHARE" "$DEV" "$DOWNLOADS" "$PICTURES" "$VIDEOS"

LOCAL_ENV=$HOME/.env.fish
if [ ! -f "$LOCAL_ENV" ]; then
    step "creating local env file"
    echo "set -Ux DOTFILES $DOTFILES" >"$LOCAL_ENV"
    info "created $LOCAL_ENV"
    success
fi

# make scripts executable
step "scripts"
chmod -v ug+x "$DOTFILES"/scripts/*
chmod -v ug+x "$DOTFILES"/i3blocks/scripts/*
chmod -v ug+x "$DOTFILES"/rofi/scripts/*
chmod -v ug+x "$DOTFILES"/waybar/scripts/*
success

# install tools
step "tools"
source "$DOTFILES/bin/tools.sh"
success

if [ ! -d "$PICTURES/backgrounds" ]; then
    step "backgrounds"
    jj git clone https://github.com/r0nsha/backgrounds "$PICTURES/backgrounds"
    success
fi

step "tpm"
tpm_dir=$HOME/.tmux/plugins/tpm
if [ ! -d "$tpm_dir" ]; then
    jj git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
else
    info "tpm: skipped (already installed in $tpm_dir)"
fi
success

step "stow"
cd "$DOTFILES"
if ! stow .; then
    error "stow failed"
fi
success

# gnupg
mkdir -p "$HOME/.gnupg"
find ~/.gnupg -type f -exec chmod 600 {} \;
find ~/.gnupg -type d -exec chmod 700 {} \;
ln -sfv "$DOTFILES/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
ln -sfv "$DOTFILES/.pam-gnupg" "$HOME/.pam-gnupg"

# ssh
mkdir -p "$HOME/.ssh"
ln -sfv "$DOTFILES/ssh/config" ~/.ssh/config

# ly
if [ "$MACHINE" = "linux" ]; then
    sudo ln -sfv "$DOTFILES/ly/config.ini" /etc/ly/config.ini
fi

# macos defaults
if [ "$MACHINE" = "darwin" ]; then
    rm -rf "$HOME/.qutebrowser"
    ln -sv "$DOTFILES/qutebrowser" "$HOME/.qutebrowser"
fi

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

    step "fish: tide prompt"
    fish "$DOTFILES/scripts/tide_configure.fish"
    success
fi

if exists "bat"; then
    step "bat cache"
    bat cache --build
    success
fi

echo "i installed your things :)"
