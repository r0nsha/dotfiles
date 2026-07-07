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

cat "$DOTFILES/install/pepe.txt"

source "$DOTFILES/install/utils.sh"

case "$(uname)" in
Linux) MACHINE="linux" ;;
Darwin) MACHINE="darwin" ;;
*) error "unsupported operating system: $(uname)" ;;
esac

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
step "chmod"
chmod -v ug+x $DOTFILES/.local/bin/*
chmod -v ug+x $DOTFILES/.config/waybar/scripts/*
chmod -v ug+x $DOTFILES/.config/qutebrowser/userscripts/*
success

# install tools
step "tools"
source "$DOTFILES/install/platform.sh"
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

# gnupg perms (stow links files into ~/.gnupg)
mkdir -p "$HOME/.gnupg"
find ~/.gnupg -type f -exec chmod 600 {} \;
find ~/.gnupg -type d -exec chmod 700 {} \;

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

if exists "bat"; then
    step "bat cache"
    bat cache --build
    success
fi

if [ "$MACHINE" = "darwin" ]; then
    pinentry_bin="$(which pinentry-mac || true)"
    if [ -n "$pinentry_bin" ]; then
        target="pinentry-program $pinentry_bin"
        conf="$DOTFILES/.gnupg/gpg-agent.conf"
        if ! grep -Fxq "$target" "$conf"; then
            sed -i '' "s|^pinentry-program .*|$target|" "$conf"
            gpg-connect-agent reloadagent /bye
        fi
    fi
fi

if exists "bob"; then
    bob use nightly
fi

echo "i installed your things :)"
