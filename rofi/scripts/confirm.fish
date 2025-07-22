#!/usr/bin/env fish

set MESSAGE $argv[1]
if test -z "$MESSAGE"
    set MESSAGE "Are you sure?"
end

set CHOICE (printf "Yes\nNo" | rofi -dmenu -p "$MESSAGE")

switch $CHOICE
    case Yes
        exit 0
    case No
        exit 1
    case '*'
        exit 2 # cancelled
end
