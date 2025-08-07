#!/usr/bin/env fish

function usage
    echo "usage: media.fish <volume sink/source up/down/mute>|<brightness up/down>"
    exit 1
end

function type_target
    set -l type $argv[1]
    switch $type
        case sink
            echo ""
        case source
            echo --default-source
        case '*'
            echo "unsupported type $type, expected 'sink' or 'source'"
            exit 1
    end
end

function notify_volume
    set -l type $argv[1]
    set -l target (type_target $type)
    set -l title (switch $type
        case sink
            echo "󰓃 Output"
        case source
            echo "󰍬 Input"
    end)

    set -l muted (pamixer $target --get-mute)
    set -l volume (pamixer $target --get-volume)

    if "$muted" == true
        notify-send -a progress -t 1000 -h 'string:wired-tag:volume' -h "int:value:$volume" "$title volume muted" muted
    else
        notify-send -a progress -t 1000 -h 'string:wired-tag:volume' -h "int:value:$volume" "$title volume $volume%"
    end
end

function notify_brightness
    set -l gamma (hyprctl hyprsunset gamma)
    set -l gamma (math "round(($gamma / 150) * 100)")
    notify-send -a progress -t 1000 -h 'string:wired-tag:brightness' -h "int:value:$gamma" Brightness
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
    set -l target $argv[1]
    if test (pamixer $target --get-volume) -gt 0
        pamixer $target --unmute
    end
end

switch $argv[1]
    case volume
        set -l type $argv[2]
        set -l action $argv[3]
        set -l target (type_target $type)

        switch $action
            case up
                pamixer $target -i 5
                update_mute $target
                notify_volume $type
            case down
                pamixer $target -d 5
                update_mute $target
                notify_volume $type
            case mute
                pamixer $target --toggle-mute
                notify_volume $type
        end
    case brightness
        set -l action $argv[2]
        switch $action
            case up
                # brightnessctl -e4 -n2 set 5%+
                hyprctl hyprsunset gamma +5
                notify_brightness
            case down
                # brightnessctl -e4 -n2 set 5%-
                hyprctl hyprsunset gamma -5
                notify_brightness
            case reset
                hyprctl hyprsunset gamma 100
                notify_brightness
        end
    case '*'
        usage
end
