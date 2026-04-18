#!/usr/bin/env fish

function type_target
    set -l type $argv[1]
    switch $type
        case sink
            echo ""
        case source
            echo --default-source
        case '*'
            echo ""
    end
end

function get_title
    set -l type $argv[1]
    switch $type
        case sink
            echo "󰓃 Output"
        case source
            echo "󰍬 Input"
        case '*'
            echo "󰓃 Volume"
    end
end

function cache_state
    set -l type $argv[1]
    set -l target (type_target $type)

    set -l muted (pamixer $target --get-mute 2>/dev/null)
    set -l volume (pamixer $target --get-volume 2>/dev/null)

    if test -z "$volume"
        return 1
    end

    set -g last_volume_$type $volume
    set -g last_muted_$type $muted
end

function show_notification
    set -l type $argv[1]
    set -l title (get_title $type)

    set -l volume_var last_volume_$type
    set -l muted_var last_muted_$type
    set -l prev_volume $$volume_var
    set -l prev_muted $$muted_var

    cache_state $type; or return

    set -l volume $$volume_var
    set -l muted $$muted_var

    # diff against last known state; skip if unchanged
    if test "$volume" = "$prev_volume"; and test "$muted" = "$prev_muted"
        return
    end

    if test "$muted" = true
        notify-send -a progress -t 1000 -h "int:value:$volume" -h "string:x-dunst-stack-tag:volume-$type" "$title volume muted"
    else
        notify-send -a progress -t 1000 -h "int:value:$volume" -h "string:x-dunst-stack-tag:volume-$type" "$title volume $volume%"
    end
end

cache_state sink
cache_state source

pactl subscribe 2>/dev/null | while read -l line
    if string match -q "*Event 'change' on sink*" "$line"
        show_notification sink
    else if string match -q "*Event 'change' on source*" "$line"
        show_notification source
    end
end
