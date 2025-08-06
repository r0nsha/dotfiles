#!/usr/bin/env fish

cliphist list | rofi -dmenu -display-columns 2 -p cliphist | cliphist decode | wl-copy
