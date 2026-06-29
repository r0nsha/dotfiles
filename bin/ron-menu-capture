#!/usr/bin/env fish

source ~/.cache/hellwal/colors.fish

set action (echo -e "shot\nrecord\nrecord (desktop audio)\nrecord (mic audio)\nrecord (desktop + mic audio)\nrecord (webcam)\nrecord (desktop + mic + webcam audio)" | rofi -dmenu -p "screen")

if test -z $action
    exit 1
end

set region (echo -e "region\nscreen" | rofi -dmenu -p "region")

if test -z $region
    exit 1
end

wait # wait for rofi to exit

switch $action
    case shot
        ron-capture-screenshot --region=$region
    case record
        ron-capture-screenrecord --region=$region
    case 'record (desktop audio)'
        ron-capture-screenrecord --region=$region --desktop-audio
    case 'record (mic audio)'
        ron-capture-screenrecord --region=$region --mic-audio
    case 'record (desktop + mic audio)'
        ron-capture-screenrecord --region=$region --desktop-audio --mic-audio
    case 'record (webcam)'
        ron-capture-screenrecord --region=$region --webcam
    case 'record (desktop + mic + webcam audio)'
        ron-capture-screenrecord --region=$region --desktop-audio --mic-audio --webcam
end
