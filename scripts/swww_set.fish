#!/usr/bin/env fish
# Changes the wallpaper to the given image and updates the updates the desktop according to the wallpaper's colors.

set img $argv[1]
swww img --resize=fit "$img" --transition-fps=120 --transition-step=4 --transition-type=random
ln -sf "$img" ~/.cache/swww/.current_background
