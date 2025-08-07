#!/usr/bin/env fish

function usage
    echo "usage: media.fish <volume sink/source up/down/mute>|<brightness up/down>"
    exit 1
end

function notify_volume
    set -l title $argv[1]
    set -l muted (pamixer --get-mute)
    set -l volume (pamixer --get-volume)

    if "$muted" == true
        notify-send -a progress -t 1000 -h 'string:wired-tag:volume' -h "int:value:$volume" "$title volume $(pamixer --get-volume-human)" muted
    else
        notify-send -a progress -t 1000 -h 'string:wired-tag:volume' -h "int:value:$volume" "$title volume $(pamixer --get-volume-human)"
    end
end

function notify_brightness
    notify-send -a progress -t 1000 -h 'string:wired-tag:brightness' -h "int:value:$target" Brightness
end

# notify_track() {
# 	# wait for mpris to update
# 	sleep 0.4
# 	art_url="$(playerctl metadata -f '{{mpris:artUrl}}' | sed 's/file:\/\///')"
# 	if [ -z "$art_url" ]; then
# 		notify-send -h 'string:wired-tag:player' -t 10000 'Player' "$(playerctl metadata -f '{{artist}} —  {{title}}')"
# 	else
# 		notify-send -h 'string:wired-tag:player' -t 10000 -h "string:image-path:$art_url" 'Player' "$(playerctl metadata -f '{{artist}} —  {{title}}')"
# 	fi
# }

function update_mute
    if test (pamixer --get-volume) -gt 0
        pamixer --unmute
    end
end

switch $argv[1]
    case volume
        switch $argv[2]
            case sink
                set target ""
                set title "󰓃 Output"
            case source
                set target --default-source
                set title "󰍬 Input"
            case '*'
                usage
        end

        switch $argv[3]
            case up
                pamixer -i 5 $target
                update_mute
                notify_volume $title
            case down
                pamixer -d 5 $target
                update_mute
                notify_volume $title
            case mute
                pamixer --toggle-mute
                notify_volume $title
            case mute-mic
                pamixer --default-source --toggle-mute
                notify_volume
        end
    case '*'
        usage
end
