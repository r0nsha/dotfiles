#!/usr/bin/env bash

# Install GTK user theme
if [ "$MACHINE" = "linux" ]; then
	running "installing GTK theme..."
	GTK_THEMES=$HOME/.local/share/themes
	mkdir -p $GTK_THEMES
	# sudo bash -c "$DOTFILES/gtk/Kanagawa-GTK-Theme/themes/install.sh --dest $GTK_THEMES --name Kanagawa --theme yellow --size compact --tweaks dragon black float"
	sudo bash -c "$DOTFILES/gtk/Rose-Pine-GTK-Theme/themes/install.sh --dest $GTK_THEMES --name Rose_Pine --theme default --size standard --tweaks black"
	success "installed GTK theme"
fi
