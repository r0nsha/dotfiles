#!/usr/bin/env fish

set hellwal_args

if test "$THEME" = light
    set -a hellwal_args --light
else
    set -a hellwal_args --dark
    set -a hellwal_args --bright-offset 0.25
end

hellwal -q -i ~/.cache/swww/.current_background $hellwal_args --check-contrast --script "~/.config/scripts/color_my_system.fish"
