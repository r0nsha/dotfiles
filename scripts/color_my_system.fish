#!/usr/bin/env fish

mkdir -p ~/.config/wired
rm -f ~/.config/wired/wired.ron
ln -sf ~/.cache/wal/wired.ron ~/.config/wired/wired.ron

mkdir -p ~/.config/qt5ct/colors
rm -f ~/.config/qt5ct/colors/colors.conf
ln -sf ~/.cache/wal/qt.conf ~/.config/qt5ct/colors/colors.conf

mkdir -p ~/.config/qt6ct/colors
rm -f ~/.config/qt6ct/colors/colors.conf
ln -sf ~/.cache/wal/qt.conf ~/.config/qt6ct/colors/colors.conf

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
