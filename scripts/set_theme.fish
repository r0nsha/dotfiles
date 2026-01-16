#!/usr/bin/env fish

set color $argv[1]

switch $color
    case dark
        set new_theme dark
    case light
        set new_theme light
    case toggle
        if test -f ~/.cache/theme
            set theme (cat ~/.cache/theme)
            switch $theme
                case dark
                    set new_theme light
                case light
                    set new_theme dark
            end
        else
            set new_theme dark
        end
    case '*'
        echo "usage: set_theme.fish <dark|light|toggle>"
        exit 1
end

echo "$new_theme" >~/.cache/theme
set -Ux THEME "$new_theme"

if test "$new_theme" = light
    set -Ux BAT_THEME_LIGHT $new_theme
    set -Ue BAT_THEME_DARK
else
    set -Ux BAT_THEME_DARK $new_theme
    set -Ue BAT_THEME_LIGHT
end

if command -vq wal
    ~/.config/scripts/wal.fish
else
    ~/.config/scripts/color_my_system.fish
end
