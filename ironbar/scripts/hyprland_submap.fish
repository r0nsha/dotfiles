#!/usr/bin/env fish

function print_submap
    set -l submap $argv[1]
    if test -n "$submap"; and test "$submap" != default
        echo "  $submap "
    else
        echo ""
    end
end

print_submap (hyprctl submap)

function handle
    switch $argv[1]
        case 'submap*'
            print_submap (string split '>>' $argv)[2]
    end
end

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read line
    handle "$line"
end
