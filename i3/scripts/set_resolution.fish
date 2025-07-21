#!/usr/bin/env fish
set -l dp (xrandr --listactivemonitors | awk '{print $NF}' | tail -n 1)
set -l mode "5120x1440_120.00"
# xrandr --newmode "$mode" 1324.26 5120 5560 6136 7152 1440 1441 1444 1543 -HSync +VSync
# xrandr --newmode "$mode" 1324.26 5120 5560 6136 7152 1440 1441 1444 1543 -HSync +VSync
# xrandr --addmode $dp "$mode"
# xrandr --output $dp --mode "$mode" --rate 120
