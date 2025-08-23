#!/usr/bin/env fish

ln -sf ~/.cache/wal/wired.ron ~/.config/wired.ron

mkdir -p ~/.config/qt5ct/colors
ln -sf ~/.cache/wal/qt.conf ~/.config/qt5ct/colors/colors.conf

mkdir -p ~/.config/qt6ct/colors
ln -sf ~/.cache/wal/qt.conf ~/.config/qt6ct/colors/colors.conf

pkill -SIGUSR1 kitty
pkill -SIGUSR2 waybar

if pgrep qutebrowser
    qutebrowser :config-source
end

tmux source-file ~/.config/tmux/tmux.conf

if test -z $COLORS_CHANGED; or test $COLORS_CHANGED -eq 0
    set -Ux COLORS_CHANGED 1
else
    set -Ux COLORS_CHANGED 0
end
