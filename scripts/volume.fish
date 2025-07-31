#!/usr/bin/env fish

set sink (pactl get-default-sink)

function _notify
    dunstify -r 69 -t 1000 -u low "$argv[1]"
end

function update_statusbar
    pkill -s SIGUSR1 i3blocks
end

function curr_volume
    echo "$(pactl get-sink-volume "$sink" | rg -o "(\d+)%" | head -1 | sed 's/%//')"
end

function toggle_mute
    set -l muted (pactl get-sink-mute @DEFAULT_SINK@ | awk -F': ' '{print $2}')
    pactl set-sink-mute "$sink" toggle
    if test "$muted" = yes
        _notify "Volume $(curr_volume)%"
    else
        _notify "Volume muted"
    end
end

function increase_volume
    set_volume "+$argv[1]"
end

function decrease_volume
    set_volume "-$argv[1]"
end

function set_volume
    set -l vol $argv[1]

    set -l curr_vol (curr_volume)
    set -l new_vol (math "$curr_vol + $vol")
    set new_vol (math "round($new_vol / 5) * 5")

    if test "$new_vol" -gt 200
        set new_vol 200
    else if test "$new_vol" -lt 0
        set new_vol 0
    end

    pactl set-sink-volume "$sink" "$new_vol%"

    if test "$new_vol" -gt 0
        pactl set-sink-mute "$sink" no
    end

    _notify "Volume $new_vol%"
end

if test -z "$argv[1]"
    echo "usage: volume.fish <up/down/mute/set>"
    exit
end

switch $argv[1]
    case up
        increase_volume 5
    case down
        decrease_volume 5
    case mute
        toggle_mute
    case '*'
        set_volume $argv[1]
end
