#!/usr/bin/env bash
#
# install.sh installs my things.

set -e
set -o pipefail
set -u
set -x

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
    echo "Error: Unsupported operating system. Exiting." >&2
    exit 1
fi

cd $DOTFILES
mkdir -p $LOCAL_BIN $LOCAL_SHARE $DOWNLOADS        # create required directories
echo "set -Ux DOTFILES $DOTFILES" >$HOME/.env.fish # create local env file
chmod ug+x $DOTFILES/hooks/*                       # make git hooks executable

# init git submodules
git submodule init
git submodule update --init --recursive

ln -sf $DOTFILES/wallpapers $HOME/Pictures/Wallpapers # link wallpapers

# load dconf settings
if exists "dconf"; then
    dconf load / <$DOTFILES/dconf/settings.ini
fi

# load gtk theme

if [ "$MACHINE" = "linux" ]; then
    GTK_THEMES="$LOCAL_SHARE/themes"
    GTK_ICONS="$LOCAL_SHARE/icons"

    # Create directories, similar to os.makedirs(..., exist_ok=True)
    mkdir -p "$GTK_THEMES"
    mkdir -p "$GTK_ICONS"

    # commands(
    #     [
    #         f'sudo bash -c "{env.dirs.dotfiles}/gtk/Rose-Pine-GTK-Theme/themes/install.sh --dest {gtk_themes} --name Rose-Pine --theme default --size compact --tweaks black"',
    #         f"cp -r {env.dirs.dotfiles}/gtk/Rose-Pine-GTK-Theme/icons {gtk_icons}",
    #     ]
    # )
fi

if [ "$MACHINE" = "darwin" ]; then
    source $DOTFILES/bin/macos_defaults.sh
fi

echo "i installed your things :)"
