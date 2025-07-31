#!/usr/bin/env fish

while true
    # Output current layout
    xkb-switch -f | awk '{ print "  " $0 " " }' || sleep 1

    # Wait for layout change
    xkb-switch -w
end
