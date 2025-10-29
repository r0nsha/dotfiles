#!/usr/bin/env fish

source ~/.cache/wal/colors.fish

function notify
    notify-send screen "$argv"
end

function notify_error
    notify-send -t 10000 -u critical "screen error" "$argv"
end

function select_region
    set background (test -n $color0; and echo "$(echo $color0)aa"; or echo "#d0d0d0aa")
    set border (test -n $color5; and echo "$color5"; or echo "#ffffff")
    set selection (test -n $color7; and echo "$(echo $color7)22"; or echo "#00000022")
    slurp -b $background -c $border -s $selection -w 2
end

function select_window
    set workspaces "$(hyprctl monitors -j | jq -r 'map(.activeWorkspace.id)')"
    set windows "$(hyprctl clients -j | jq -r --argjson workspaces "$workspaces" 'map(select([.workspace.id] | inside($workspaces)))' )"
    set geom (echo "$windows" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp)
    echo $geom
end

set action (echo -e "shot\nrecord\nrecord (with audio)\nrecord (with mic)\nrecord (gif)" | rofi -dmenu -p "screen")

if test -z $action
    exit 1
end

set region (echo -e "region\nwindow\nscreen" | rofi -dmenu -p "region")

if test -z $region
    exit 1
end

switch $action
    case shot
        set to (echo -e "clipboard\nfile\nui" | rofi -dmenu -p "to")
    case record 'record (with audio)' 'record (with mic)'
        set to (echo -e "file\nui" | rofi -dmenu -p "to")
    case 'record (gif)'
        set to file
end

if test -z $to
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
    case 'record (with mic)'
        set action record
        set -a screen_args --mic
end

~/.config/scripts/screen.fish --action=$action --region=$region --to=$to $screen_args
