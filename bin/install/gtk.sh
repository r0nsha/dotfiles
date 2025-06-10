#!/usr/bin/env bash

# Install GTK user theme
if [ "$MACHINE" = "linux" ]; then
	gtk_themes=$HOME/.local/share/themes
	gtk_icons=$HOME/.local/share/icons

	mkdir -p $gtk_themes $gtk_icons

	running "installing GTK theme..."
	# sudo bash -c "$DOTFILES/gtk/Kanagawa-GTK-Theme/themes/install.sh --dest $gtk_themes --name Kanagawa --theme yellow --size compact --tweaks dragon black float"
	sudo bash -c "$DOTFILES/gtk/Rose-Pine-GTK-Theme/themes/install.sh --dest $gtk_themes --name Rose-Pine --theme default --size compact --tweaks black float"
	success "installed GTK theme"

	running "installing GTK icons..."
	cp -r $DOTFILES/gtk/Rose-Pine-GTK-Theme/icons/* $gtk_icons/.
	success "installed GTK icons"

	running "installing GTK cursor..."
	cursor_url=https://github.com/rose-pine/cursor/releases/download/v1.1.0/BreezeX-RosePine-Linux.tar.xz
	cursor_tar=$DOWNLOADS/Rose-Pine.tar.xz
	running "downloading GTK cursor from $cursor_url..."
	wget -nv -O $cursor_tar $cursor_url
	running "installing $cursor_tar in $gtk_icons..."
	tar -xvf $cursor_tar -C $gtk_icons
	success "installed GTK cursor"
fi
