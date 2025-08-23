#!/usr/bin/env fish

set dir $argv[1]
if test -z "$dir"
    set dir ~/pictures/backgrounds
end

set picked (fd . ~/pictures/backgrounds | xargs -I% basename % | rofi -dmenu -p "background")

~/.config/scripts/set_background.fish $dir/$picked
