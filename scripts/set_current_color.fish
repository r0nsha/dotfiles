#!/usr/bin/env fish

set color $argv[1]

if test "$color" != dark; and test "$color" != light
    echo "usage: set_current_color.fish <dark|light>"
    exit 1
end

echo "$color" >~/.cache/current_color

~/.config/scripts/wal.fish
