#!/usr/bin/env fish

function usage
    echo "usage: screen.fish -a/--action <shot|record> -r/--region <region|window|screen> -t/--to <clipboard|ui|file> [--gif] [--audio|--mic] [-h/--help]"
end

argparse h/help "a/action=" "r/region=" "t/to=" gif audio mic -- $argv

if set -ql _flag_h
    usage
    return 0
end

set action $_flag_a
set region $_flag_r
set to $_flag_t

if test -z "$action"; or test -z "$region"; or test -z "$to"
    usage
    return 1
end

source ~/.cache/wal/colors.fish

function notify
    notify-send screen "$argv"
end

function notify_error
    notify-send -t 10000 -u critical "screen error" "$argv"
end

function get_filename
    echo (date +%d-%m-%Y_%Hh%Mm%Ss)
end

function select_region
    set background (test -n "$color0"; and echo "$(echo $color0)aa"; or echo "#d0d0d0aa")
    set border (test -n "$color5"; and echo "$color5"; or echo "#ffffff")
    set selection (test -n "$color7"; and echo "$(echo $color7)00"; or echo "#00000022")
    set geom (slurp -b $background -c $border -s $selection -w 2)
    if test $status -ne 0
        exit 1
    end
    echo $geom
end

function select_window
    set workspaces "$(hyprctl monitors -j | jq -r 'map(.activeWorkspace.id)')"
    set windows "$(hyprctl clients -j | jq -r --argjson workspaces "$workspaces" 'map(select([.workspace.id] | inside($workspaces)))' )"
    set geom (echo "$windows" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp)
    if test $status -ne 0
        exit 1
    end
    echo $geom
end

function get_geometry
    switch $region
        case region
            select_region
        case window
            select_window
        case screen
            echo ""
    end
end

switch $action
    case shot
        set dir $XDG_PICTURES_DIR/screenshots
        mkdir -p $dir
        set file "$dir/$(get_filename).png"
        set geom (get_geometry)
        set shot_args
        if test -n "$geom"
            set shot_args -g "$geom"
        end

        grim $shot_args -t png $file

        if test $status -ne 0
            notify_error "grim failed"
            exit 1
        end

        wait # wait for grim to exit

        set copied (switch $to
            case clipboard
                wl-copy <$file
                echo screenshot
            case ui
                swappy -f $file -o $file
                wl-copy <$file
                echo screenshot
            case file
                wl-copy $file
                echo path
        end)

        notify "saved screenshot to $file, \ncopied $copied to clipboard"
    case record
        # if wf-recorder is running, stop/kill it and exit
        set -l pcount (pkill -SIGINT -c wf-recorder)
        if test $pcount -gt 0
            # unload virtual pulseaudio modules
            pactl unload-module module-null-sink
            pactl unload-module module-loopback
            exit
        end

        set dir $XDG_PICTURES_DIR/screenrecords
        mkdir -p $dir

        set recorder_args
        if set -q _flag_gif
            set ext gif
            set -a recorder_args --codec=gif
        else
            set ext mp4
            if set -q _flag_audio
                # we setup a virtual sink that combines the default sink and source, so that we can record both
                set -l virtual_sink Combined
                pactl load-module module-null-sink sink_name=$virtual_sink
                pactl load-module module-loopback sink=$virtual_sink source=$(pactl get-default-sink).monitor
                pactl load-module module-loopback sink=$virtual_sink source=(pactl get-default-source)
                set -a recorder_args --audio=$virtual_sink.monitor
            end

            if set -q _flag_mic
                set -a recorder_args --audio
            end
        end

        set file "$dir/$(get_filename).$ext"
        set geom (get_geometry)
        if test -n "$geom"
            set -a recorder_args -g "$geom"
        end

        wf-recorder $recorder_args --file=$file --overwrite
        if test $status -ne 0
            notify_error "wf-recorder failed"
            exit 1
        end

        wait # wait for wf-recorder to exit

        wl-copy $file
        set copied (switch $to
            case clipboard file
                wl-copy $file
                echo path
            case ui
                if test "$ext" != gif
                    wl-copy $file
                    shotcut $file
                    echo recording
                else 
                    echo path
                end
        end)

        notify "saved recording to $file, \ncopied $copied to clipboard"
end
