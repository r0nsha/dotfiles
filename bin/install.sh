#!/usr/bin/env bash
#
# install.sh installs my things.

cat $DOTFILES/bin/pepe.txt
exit

set -e

cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)

# chmod scripts
chmod ug+x $DOTFILES/**/*.sh

source $DOTFILES/bin/utils.sh
source $DOTFILES/bin/detect.sh

mkdir -p $DOWNLOADS
mkdir -p $HOME/.local/bin
mkdir -p $HOME/.local/share

source $DOTFILES/bin/install/git_submodules.sh
echo ""

source $DOTFILES/bin/install/env.sh
echo ""

# setup wallpapers
running "setting up wallpapers..."
ln -sf $DOTFILES/wallpapers $HOME/Pictures/Wallpapers
success "wallpapers set up"

source $DOTFILES/bin/install/gtk.sh
echo ""

source $DOTFILES/bin/install/fonts.sh
echo ""

source $DOTFILES/bin/install/dconf.sh
echo ""

source $DOTFILES/bin/install/tools.sh
echo ""

source $DOTFILES/bin/install/stow.sh
echo ""

source $DOTFILES/bin/install/shell.sh
echo ""

success 'the things all installed!'
