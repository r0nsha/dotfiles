#!/usr/bin/env fish

set color $argv[1]

if test "$color" != dark; and test "$color" != light
    echo "usage: set_current_color.fish <dark|light>"
    exit 1
end

echo "$color" >~/.cache/current_color
if set -q _update_current_color
    set -Ux _update_current_color (math "$_update_current_color + 1")
else
    set -Ux _update_current_color 1
end

~/.config/scripts/wal.fish
