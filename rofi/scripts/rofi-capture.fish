#!/usr/bin/env fish

source ~/.cache/wal/colors.fish

set action (echo -e "shot\nrecord\nrecord (desktop audio)\nrecord (mic audio)\nrecord (desktop + mic audio)\nrecord (webcam)\nrecord (desktop + mic + webcam audio)\nrecord (gif)" | rofi -dmenu -p "screen")

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
    case 'record (desktop audio)'
        set command ron-capture-screenrecord
        set -a screen_args --desktop-audio
    case 'record (mic audio)'
        set command ron-capture-screenrecord
        set -a screen_args --mic-audio
    case 'record (desktop + mic audio)'
        set command ron-capture-screenrecord
        set -a screen_args --desktop-audio --mic-audio
    case 'record (webcam)'
        set command ron-capture-screenrecord
        set -a screen_args --webcam
    case 'record (desktop + mic + webcam audio)'
        set command ron-capture-screenrecord
        set -a screen_args --desktop-audio --mic-audio --webcam
    case 'record (gif)'
        set command ron-capture-screenrecord
        set -a screen_args --gif
end

$command --region=$region $screen_args
