# load dconf settings
if which dconf &>/dev/null; then
	running "loading dconf settings..."
	dconf load / <$DOTFILES/dconf/settings.ini
	success "loaded dconf settings"
fi
