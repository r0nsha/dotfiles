#!/usr/bin/env fish

set color $argv[1]

switch $color
    case dark
        set new_color dark
    case light
        set new_color light
    case toggle
        if test -f ~/.cache/current_color
            set current_color (cat ~/.cache/current_color)
            switch $current_color
                case dark
                    set new_color light
                case light
                    set new_color dark
            end
        else
            set new_color dark
        end
    case '*'
        echo "usage: set_current_color.fish <dark|light|toggle>"
        exit 1
end

echo "$new_color" >~/.cache/current_color
set -Ux _update_current_color "$new_color"

~/.config/scripts/wal.fish
