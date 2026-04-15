#!/usr/bin/env fish

set dir $argv[1]
set -q dir[1] || set dir ~/pictures/backgrounds

set current_bg (basename (readlink ~/.cache/awww/.current_background 2>/dev/null) 2>/dev/null)

set -l items (fd . $dir)
set -l selected_idx 0

# Find selected index
for i in (seq (count $items))
    test (basename $items[$i]) = "$current_bg" && set selected_idx (math $i - 1)
end

set picked (for item in $items
    printf "%s\0icon\x1f%s\n" (basename $item) $item
end | rofi -dmenu -theme fullscreen-preview.rasi -selected-row $selected_idx)

test -z "$picked" && exit
~/.config/scripts/set_background.fish $dir/$picked
