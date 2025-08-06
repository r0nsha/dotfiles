#!/usr/bin/env fish
# Kills the currently active window.

set class (hyprctl activewindow -j | jq -r ".class")
if $class == Steam
    xdotool getactivewindow windowunmap
else
    hyprctl dispatch killactive ""
end
