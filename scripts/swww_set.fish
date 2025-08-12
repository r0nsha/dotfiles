#!/usr/bin/env fish
# Changes the wallpaper to the given image and updates the updates the desktop according to the wallpaper's colors.

# set background
set img $argv[1]
swww img --resize=fit "$img" --transition-fps=120 --transition-step=4 --transition-type=random

# link to cache so that other apps like the lockscreen can reference it
ln -sf "$img" ~/.cache/swww/.current_background

# update colors
hellwal -q -i "$img" --check-contrast --bright-offset 0.25 --skip-term-colors --script "~/.config/scripts/hellwal_colors.fish"
