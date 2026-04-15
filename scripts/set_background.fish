#!/usr/bin/env fish
# Changes the wallpaper to the given image and updates the updates the desktop according to the wallpaper's colors.

# set background
set img $argv[1]
awww img --resize=crop "$img" --transition-fps=120 --transition-step=4 --transition-type=fade

# link to cache so that other apps like the lockscreen can reference it
ln -sf "$img" ~/.cache/awww/.current_background

~/.config/scripts/wal.fish
