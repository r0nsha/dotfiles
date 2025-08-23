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
set hellwal_args

if test "$theme" = light
    set -a hellwal_args --light
else
    set -a hellwal_args --dark
end

hellwal -q -i ~/.cache/swww/.current_background $hellwal_args --check-contrast --script "~/.config/scripts/color_my_system.fish"
