#!/usr/bin/env fish

set hellwal_args
if test -f ~/.cache/current_color
    set current_color (cat ~/.cache/current_color)
    if test "$current_color" = light
        set -a hellwal_args --light
        # set -a hellwal_args --dark-offset 0.1
    else
        set -a hellwal_args --dark
        set -a hellwal_args --bright-offset 0.25
    end
else
    set -a hellwal_args --dark
    set -a hellwal_args --bright-offset 0.25
end

hellwal -q -i "~/.cache/swww/.current_background" $hellwal_args --check-contrast --script "~/.config/scripts/color_my_system.fish"
