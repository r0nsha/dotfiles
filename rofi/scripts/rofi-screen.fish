#!/usr/bin/env fish

function notify
    notify-send screen "$argv"
end

function notify_error
    notify-send -t 10000 -u critical "screen error" "$argv"
end

set options shot record
set action (echo -e "shot\nrecord" | rofi -dmenu -p "screen")

if test -z $action
    exit 1
end

set region (echo -e "screen\nregion\nwindow" | rofi -dmenu -p "region")

if test -z $region
    exit 1
end

set to (echo -e "clipboard\nui\nfile" | rofi -dmenu -p "to")

if test -z $to
    exit 1
end

sleep 0.25 # wait for rofi to exit

switch $action
    case shot
        set dir $XDG_PICTURES_DIR/screenshots
        mkdir -p $dir
        set file $dir/$(date +%d-%m-%Y_%Hh%Mm%Ss).png

        set grim_args -t png $file
        switch $region
            case screen
                # TODO: screen
                set err (grim $grim_args 2>&1 >/dev/null)

                # if grim failed, notify-send an error, otherwise, notify-send the file path and copy the path to clipboard using wl-copy
                if test $status -ne 0
                    notify_error "grim failed, cause: $err"
                    exit 1
                end

                notify-send screen "saved screenshot to $file"
                wl-copy $file
            case region
                # TODO: region
            case window
                # TODO: window
        end
end
