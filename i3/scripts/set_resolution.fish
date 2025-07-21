#!/usr/bin/env fish
set -l dp (xrandr --listactivemonitors | awk '{print $NF}' | tail -n 1)
xrandr --output $dp --size 5120x1440 --rate 120.00
