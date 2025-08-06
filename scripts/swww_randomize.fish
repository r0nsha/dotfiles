#!/usr/bin/env fish
# Changes the wallpaper to a randomly chosen image in a given directory
# at a set interval.

set default_interval 300

set dir $argv[1]
set interval $argv[2]

if test -z "$dir"
    printf "Usage:\n\t\e[1m%s\e[0m \e[4mDIRECTORY\e[0m [\e[4mINTERVAL\e[0m]\n" "$argv[1]"
    printf "\tChanges the wallpaper to a randomly chosen image in DIRECTORY every\n\tINTERVAL seconds (or every %d seconds if unspecified)." "$default_interval"
    exit 1
end

if ! test -d "$dir"
    printf "Error: Directory \e[4m%s\e[0m does not exist.\n" "$dir"
    exit 1
end

if string length -q -- $interval
    if not string match -qr '^[0-9]+$' -- $interval
        printf "Error: Interval \e[4m%s\e[0m is not a number.\n" $interval
        exit 1
    end
else
    set interval $default_interval
end

# See swww-img(1)
set resize_type fit
set -x SWWW_TRANSITION_FPS (set -q SWWW_TRANSITION_FPS; and echo $SWWW_TRANSITION_FPS; or echo 60)
set -x SWWW_TRANSITION_STEP (set -q SWWW_TRANSITION_STEP; and echo $SWWW_TRANSITION_STEP; or echo 2)

while true
    fd . $dir -tf \
        | while read img
        echo (cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 8):$img
    end \
        | sort -n | cut -d':' -f2- \
        | while read img
        swww img --resize="$resize_type" "$img"
        sleep $interval
    end
end
