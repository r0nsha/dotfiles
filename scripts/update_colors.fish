#!/usr/bin/env fish

pkill -SIGUSR2 waybar

ln -sf ~/.cache/hellwal/wired.ron ~/.config/wired.ron

mkdir -p ~/.config/qt5ct
ln -sf ~/.cache/hellwal/qt5ct.conf ~/.config/qt5ct/qt5ct.conf

mkdir -p ~/.config/qt6ct
ln -sf ~/.cache/hellwal/qt6ct.conf ~/.config/qt6ct/qt6ct.conf
