#!/usr/bin/env fish

function get_display_name
    set -l name $argv[1]
    set -l list $argv[2]

    set -l desc (pactl list $list | grep -A 2 "Name: $name" | grep 'Description:' | string split ':' --fields 2 | string trim)
    if test -z "$desc"
        echo "$name"
    else
        echo "$desc"
    end
end

function display_sound
    set -l sink (
        get_display_name (pactl get-default-sink) sinks
    )
    set -l sink_display (
        if test -n "$sink"
            echo "󰓃 $sink"
        else
            echo "󰓄 No output"
        end
    )
    set -l source (
        get_display_name (pactl get-default-source) sources
    )
    set -l source_display (
        if test -n "$source"
            echo "󰍬 $source"
        else
            echo "󰍭 No input"
        end
    )

    echo " $sink_display $source_display "
end

display_sound

pactl subscribe | while read line
    if string match -q '*change*' -- $line
        display_sound
    end
end
