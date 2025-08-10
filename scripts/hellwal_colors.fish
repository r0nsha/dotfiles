#!/usr/bin/env fish

ln -sf ~/.cache/hellwal/wired.ron ~/.config/wired.ron

mkdir -p ~/.config/qt5ct/colors
ln -sf ~/.cache/hellwal/qt.conf ~/.config/qt5ct/colors/colors.conf

mkdir -p ~/.config/qt6ct/colors
ln -sf ~/.cache/hellwal/qt.conf ~/.config/qt6ct/colors/colors.conf

pkill -SIGUSR2 waybar
qutebrowser :config-source
pkill -SIGUSR1 kitty
set -U _hellwal_update (date +%s)
