#!/usr/bin/env fish

# Set defaults if not already set
set -q font; or set font monospace
set -q font_weight; or set font_weight bold

while true
    # Output current layout
    xkb-switch -p | awk -v font="$font" -v font_weight="$font_weight" '{print toupper($0)}' || sleep 1

    # Wait for layout change
    xkb-switch -w
end
