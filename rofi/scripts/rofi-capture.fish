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

set command
set screen_args
switch $action
    case shot
        set command ron-capture-screenshot
    case record
        set command ron-capture-screenrecord
    case 'record (gif)'
        set command ron-capture-screenrecord
        set -a screen_args --gif
    case 'record (with audio)'
        set command ron-capture-screenrecord
        set -a screen_args --audio
end

$command --region=$region $screen_args
