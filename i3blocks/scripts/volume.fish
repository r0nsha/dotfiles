#!/usr/bin/env fish

set color_muted "#767676"
set color_low "#989898"
set color_medium "#c0c0c0"
set color_high "#ffffff"
set color_alert "#ff5f59"

function display_volume
    set -l muted (pactl get-sink-mute @DEFAULT_SINK@ | awk -F': ' '{print $2}')

    if test "$muted" = yes
        echo " <span color='$color_muted'>󰝟 Muted</span> "
        return
    end

    set -l volume (pactl get-sink-volume @DEFAULT_SINK@ | rg -o "(\d+)%" | head -1 | sed 's/%//')

    if test "$volume" -eq 0; or test "$muted" = yes
        set color $color_muted
        set icon "󰝟"
        set volume Muted
    else if test "$volume" -lt 33
        set color $color_low
        set icon "󰕿"
    else if test "$volume" -lt 66
        set color $color_medium
        set icon "󰖀"
    else if test "$volume" -lt 150
        set color $color_high
        set icon "󰕾"
    else
        set color $color_alert
        set icon "󰕾"
    end

    if test "$volume" != Muted
        set volume "$volume%"
    end

    echo " <span color='$color'>$icon $volume</span> "
end

display_volume

pactl subscribe | while read line
    if string match -q '*change*' -- $line; and string match -q '*sink*' -- $line
        display_volume
    end
end
