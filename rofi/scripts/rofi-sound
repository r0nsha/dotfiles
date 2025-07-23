#!/usr/bin/env fish

# A rofi menu for selecting sound devices using PulseAudio. Supports both outputs and inputs.

set ROFI_OPTIONS -theme-str "window {width: 15%;}"

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

function get_sink_display_name
    get_display_name $argv[1] sinks
end

function get_source_display_name
    get_display_name $argv[1] sources
end

function list_devices
    set -l default_sink (pactl info | grep 'Default Sink:' | string split ':' --fields 2 | string trim)
    set -l default_sink_display_name (get_sink_display_name "$default_sink")

    set -l default_source (pactl info | grep 'Default Source:' | string split ':' --fields 2 | string trim)
    set -l default_source_display_name (get_source_display_name "$default_source")

    set -l options "Output:\t$(get_sink_display_name $default_sink)\nInput:\t$(get_source_display_name $default_source)"
    set picked (echo -e "$options" | rofi -dmenu -p "Sound Devices" $ROFI_OPTIONS)

    if string match -q "Output:*" $picked
        pick_sink
    end

    if string match -q "Input:*" $picked
        pick_source
    end
end

function pick_sink
    set -l sinks (pactl list sinks | rg "Name:" | cut -d' ' -f2-)
    set -l options (
        for sink in $sinks
            echo "$(get_sink_display_name $sink) | $sink"
        end | sort | string join "\n"
    )
    set picked (echo -e "$options" | rofi -dmenu -p "Select Output" $ROFI_OPTIONS)
    set -l parts (echo $picked | string split ' | ' | string trim)
    set -l name $parts[1]
    set -l sink $parts[2]
    pactl set-default-sink "$sink"
    notify-send "Default output set to '$name'"
end

function pick_source
    set -l sources (pactl list sources | rg "Name:" | cut -d' ' -f2-)
    set -l options (
        for source in $sources
            echo "$(get_source_display_name $source) | $source"
        end | sort | string join "\n"
    )
    set picked (echo -e "$options" | rofi -dmenu -p "Select Output" $ROFI_OPTIONS)
    set -l parts (echo $picked | string split ' | ' | string trim)
    set -l name $parts[1]
    set -l source $parts[2]
    pactl set-default-source "$source"
    notify-send "Default output set to '$name'"
end

list_devices
