#!/usr/bin/env fish

set dir $argv[1]
if test -z "$dir"
    set dir ~/pictures/backgrounds
end

set picked (for bg in (fd . ~/pictures/backgrounds)
    set -l name (basename $bg)
    echo -en "$name\0icon\x1f$bg\n"
end | rofi -dmenu -theme fullscreen-preview.rasi)

if test -z "$picked"
    exit
end

~/.config/scripts/set_background.fish $dir/$picked
