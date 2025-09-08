#!/usr/bin/env fish

set res (hyprctl activeworkspace | string match -r 'workspace ID (\d+) \((.*)\)' | string split ' ')
if test $status -ne 0; or test -z "$res"
    exit 1
end

set wid $res[-2]
set name $res[-1]

if test "$name" = "$wid"
    set desc $name
else
    set desc "$name ($wid)"
end

set new_name (rofi -dmenu -p "rename workspace `$desc` to" -theme-str 'entry { placeholder: "new name..."; } window { height: 10%; }')
if test -z "$new_name"
    exit 1
end

hyprctl dispatch renameworkspace $wid $new_name
