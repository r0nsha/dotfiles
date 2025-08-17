#!/usr/bin/env fish

ln -sf ~/.cache/hellwal/wired.ron ~/.config/wired.ron

mkdir -p ~/.config/qt5ct/colors
ln -sf ~/.cache/hellwal/qt.conf ~/.config/qt5ct/colors/colors.conf

mkdir -p ~/.config/qt6ct/colors
ln -sf ~/.cache/hellwal/qt.conf ~/.config/qt6ct/colors/colors.conf

pkill -SIGUSR1 kitty
pkill -SIGUSR2 waybar

if pgrep qutebrowser
    qutebrowser :config-source
end

tmux source-file ~/.config/tmux/tmux.conf
