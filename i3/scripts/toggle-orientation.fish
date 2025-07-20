#!/usr/bin/env fish
set layout (i3-msg -t get_tree | jq -r '.. | objects | select(.focused? == true).layout')
if test "$layout" = splitv
    i3-msg layout splith
else
    i3-msg layout splitv
end
