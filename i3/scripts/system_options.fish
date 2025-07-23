#!/usr/bin/env fish
xss-lock --transfer-sleep-lock -- betterlockscreen -l
betterlockscreen -u ~/Pictures/Wallpapers
feh --randomize --bg-scale --slideshow-delay 301 ~/Pictures/Wallpapers

sleep 2
xset r rate 250 30
xrandr --size 5120x1440
xrandr --output DP-4 --size 5120x1440 --rate 120.00
