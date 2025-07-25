#!/usr/bin/env fish

while true
    # Output current layout
    xkb-switch -p | awk '{ print " " toupper($0) " " }' || sleep 1

    # Wait for layout change
    xkb-switch -w
end
