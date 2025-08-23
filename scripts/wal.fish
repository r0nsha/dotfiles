#!/usr/bin/env fish

function read_theme
    if test -f ~/.cache/theme
        set theme (cat ~/.cache/theme)
    else
        echo $THEME
    end

    switch $theme
        case dark
            echo dark
        case light
            echo light
        case '*'
            echo dark
    end
end

set theme (read_theme)
set walargs

if test "$theme" = light
    set -a walargs -l
    set -a walargs --saturate 0.15
    set -a walargs --contrast 1.0
else
    set -a walargs --saturate 0.3
    set -a walargs --contrast 1.0
end

wal -n -e --backend colorthief $walargs -i ~/.cache/swww/.current_background -o ~/.config/scripts/color_my_system.fish
