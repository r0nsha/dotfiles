running "installing tools..."
source $DOTFILES/bin/install/tools/shared.sh
case "$MACHINE" in
linux) source $DOTFILES/bin/install/tools/linux.sh ;;
macos) source $DOTFILES/bin/install/tools/macos.sh ;;
*) ;;
esac
success "tools installed"

echo ""
