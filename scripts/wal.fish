#!/usr/bin/env fish

set -l theme (get_theme)

set walargs
if test "$theme" = light
    set -a walargs -l
    set -a walargs --saturate 0.15
    set -a walargs --contrast 1.0
else
    set -a walargs --saturate 0.3
    set -a walargs --contrast 1.0
end

wal -s -n -e --backend colorthief --cols16 lighten $walargs -i ~/.cache/awww/.current_background -o ~/.config/scripts/color_my_system.fish
