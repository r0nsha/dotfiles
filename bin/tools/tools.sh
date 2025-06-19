#!/usr/bin/env bash

set -e

running "installing tools..."
source $DOTFILES/bin/tools/shared.sh
case "$MACHINE" in
linux) source $DOTFILES/bin/tools/linux.sh ;;
macos) source $DOTFILES/bin/tools/macos.sh ;;
*) ;;
esac
success "tools installed"

echo ""
