#!/usr/bin/env fish

ln -sf ~/.config/wired.ron ~/.cache/wal/wired.ron

mkdir -p ~/.config/qt5ct/colors
ln -sf ~/.config/qt5ct/colors/colors.conf ~/.cache/wal/qt.conf

mkdir -p ~/.config/qt6ct/colors
ln -sf ~/.config/qt6ct/colors/colors.conf ~/.cache/wal/qt.conf

ln -sf ~/.config/kitty/theme_$THEME.conf ~/.config/kitty/current_theme.conf
pkill -SIGUSR1 kitty

pkill -SIGUSR2 waybar

if pgrep qutebrowser
    qutebrowser :config-source
end

tmux source-file ~/.config/tmux/tmux.conf

if test -z "$THEME_CHANGED"; or test "$THEME_CHANGED" -eq 0
    set -gx THEME_CHANGED 1
else
    set -gx THEME_CHANGED 0
end
