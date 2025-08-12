#!/usr/bin/env fish

function usage
    echo "usage: screen.fish -a/--action <shot|record> -r/--region <region|window|screen> -t/--to <clipboard|ui|file>"
end

argparse h/help "a/action=" "r/region=" "t/to=" -- $argv

if set -ql _flag_h
    usage
    return 0
end

set -l action $_flag_a
set -l region $_flag_r
set -l to $_flag_t

if test -z $action; or test -z $region; or test -z $to
    usage
    return 1
end

source ~/.cache/hellwal/colors.fish

function notify
    notify-send screen "$argv"
end

function notify_error
    notify-send -t 10000 -u critical "screen error" "$argv"
end

function get_filename
    echo $argv/$(date +%d-%m-%Y_%Hh%Mm%Ss).png
end

function select_region
    set background (test -n $color0; and echo "$(echo $color0)aa"; or echo "#d0d0d0aa")
    set border (test -n $color5; and echo "$color5"; or echo "#ffffff")
    set selection (test -n $color7; and echo "$(echo $color7)22"; or echo "#00000022")
    slurp -b $background -c $border -s $selection -w 2
end

function select_window
    set workspaces "$(hyprctl monitors -j | jq -r 'map(.activeWorkspace.id)')"
    set windows "$(hyprctl clients -j | jq -r --argjson workspaces "$workspaces" 'map(select([.workspace.id] | inside($workspaces)))' )"
    set geom (echo "$windows" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp)
    echo $geom
end

switch $action
    case shot
        set dir $XDG_PICTURES_DIR/screenshots
        mkdir -p $dir
        set file (get_filename $dir)

        set geom (
            switch $region
                case region
                    echo "-g $(select_region)"
                case window
                    echo "-g $(select_window)"
                case screen
                    echo ""
            end
        )

        if test -n $geom
            set err (grim -t png $geom $file 2>&1 >/dev/null)
        else
            set err (grim -t png $file 2>&1 >/dev/null)
        end

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

        notify "saved screenshot to $file\ncopied $copied to clipboard"
end
