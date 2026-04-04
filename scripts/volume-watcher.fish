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

function show_notification
    set -l type $argv[1]
    set -l target (type_target $type)
    set -l title (get_title $type)

    set -l muted (pamixer $target --get-mute 2>/dev/null)
    set -l volume (pamixer $target --get-volume 2>/dev/null)

    if test -z "$volume"
        return
    end

    if test "$muted" = true
        notify-send -a progress -t 1000 -h 'string:wired-tag:volume' -h "int:value:$volume" "$title volume muted" muted
    else
        notify-send -a progress -t 1000 -h 'string:wired-tag:volume' -h "int:value:$volume" "$title volume $volume%"
    end
end

pactl subscribe 2>/dev/null | while read -l line
    if string match -q "*Event 'change' on sink*" "$line"
        show_notification sink
    else if string match -q "*Event 'change' on source*" "$line"
        show_notification source
    end
end
