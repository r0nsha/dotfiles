#!/usr/bin/env fish
xss-lock --transfer-sleep-lock -- betterlockscreen -l
xset r rate 250 30
xrandr --size 5120x1440
xrandr --output DP-4 --size 5120x1440 --rate 120.00
