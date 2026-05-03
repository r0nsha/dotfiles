#!/usr/bin/env fish

set walargs
if test "$(ron-theme-get)" = light
    set -a walargs -l
    set -a walargs --saturate 0.15
    set -a walargs --contrast 1.0
else
    set -a walargs --saturate 0.3
    set -a walargs --contrast 1.0
end

wal -s -n -e \
    --backend colorthief \
    --cols16 dual \
    $walargs \
    -i ~/.cache/current_background \
    -o ~/.config/scripts/color_my_system.fish
