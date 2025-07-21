#!/usr/bin/env fish
set dp (xrandr --listactivemonitors | awk '{print $NF}' | tail -n 1)
xrandr --newmode "5120x1440_120.00" 1324.26 5120 5560 6136 7152 1440 1441 1444 1543 -HSync +Vsync
xrandr --addmode $dp "5120x1440_120.00"
xrandr --output $dp --mode "5120x1440_120.00" --rate 120
