#!/usr/bin/env fish

source ~/.cache/wal/colors.fish

set action (echo -e "shot\nrecord\nrecord (with audio)\nrecord (gif)" | rofi -dmenu -p "screen")

if test -z $action
    exit 1
end

set region (echo -e "region\nscreen" | rofi -dmenu -p "region")

if test -z $region
    exit 1
end

wait # wait for rofi to exit

set screen_args
switch $action
    case 'record (gif)'
        set action record
        set -a screen_args --gif
    case 'record (with audio)'
        set action record
        set -a screen_args --audio
end

~/.config/scripts/capture.fish --action=$action --region=$region $screen_args
