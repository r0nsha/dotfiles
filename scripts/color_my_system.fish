#!/usr/bin/env fish

ln -sf ~/.config/wired.ron ~/.cache/wal/wired.ron

mkdir -p ~/.config/qt5ct/colors
ln -sf ~/.config/qt5ct/colors/colors.conf ~/.cache/wal/qt.conf

mkdir -p ~/.config/qt6ct/colors
ln -sf ~/.config/qt6ct/colors/colors.conf ~/.cache/wal/qt.conf

ln -sf ~/.config/kitty/theme_(get_theme).conf ~/.config/kitty/current_theme.conf
mkdir -p ~/.cache/ghostty
ln -sf ~/.config/ghostty/theme_(get_theme).ghostty ~/.cache/ghostty/current_theme.ghostty
pkill -SIGUSR1 kitty
pkill -SIGUSR2 ghostty
pkill -SIGUSR2 waybar

if pgrep qutebrowser
    qutebrowser :config-source
end

tmux source-file ~/.config/tmux/tmux.conf
