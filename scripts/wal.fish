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
    set -a walargs --cols16 lighten
else
    set -a walargs --cols16 darken
end

wal -n -e --saturate 0.3 --backend colorthief $walargs -i ~/.cache/swww/.current_background -o ~/.config/scripts/color_my_system.fish
