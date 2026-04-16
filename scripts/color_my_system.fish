#!/usr/bin/env fish

# qt
mkdir -p ~/.config/qt5ct/colors
rm -f ~/.config/qt5ct/colors/colors.conf
ln -sf ~/.cache/wal/qt.conf ~/.config/qt5ct/colors/colors.conf

mkdir -p ~/.config/qt6ct/colors
rm -f ~/.config/qt6ct/colors/colors.conf
ln -sf ~/.cache/wal/qt.conf ~/.config/qt6ct/colors/colors.conf

# waybar
ln -sf ~/.cache/wal/waybar.css ~/.config/waybar/style.css

# kitty
ln -sf ~/.config/kitty/theme_(get_theme).conf ~/.config/kitty/current_theme.conf
pkill -SIGUSR1 kitty

# ghostty
mkdir -p ~/.cache/ghostty
ln -sf ~/.config/ghostty/theme_(get_theme).ghostty ~/.cache/ghostty/current_theme.ghostty
pkill -SIGUSR2 ghostty

# mako
mkdir -p ~/.config/mako
rm -f ~/.config/mako/config
cat ~/.cache/wal/colors-mako ~/.config/mako/base-config >~/.config/mako/config
if pgrep mako
    makoctl reload
end

if pgrep qutebrowser
    qutebrowser :config-source
end

tmux source-file ~/.config/tmux/tmux.conf
