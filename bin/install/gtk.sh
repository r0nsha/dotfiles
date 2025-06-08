# Install GTK user theme
if [ "$MACHINE" = "linux" ]; then
	running "installing GTK theme..."
	GTK_THEMES=$HOME/.local/share/themes
	mkdir -p $GTK_THEMES
	sudo bash -c "$DOTFILES/gtk/Kanagawa-GTK-Theme/themes/install.sh --dest $GTK_THEMES --name Kanagawa --theme yellow --size compact --tweaks dragon black float"
	success "installed GTK theme"

	# running "installing GTK icons..."
	# GTK_ICONS=$HOME/.local/share/icons
	# mkdir -p $GTK_ICONS
	# cp -r $DOTFILES/gtk/Kanagawa-GTK-Theme/icons/* $GTK_ICONS/.
	# success "installed GTK icons"
fi
