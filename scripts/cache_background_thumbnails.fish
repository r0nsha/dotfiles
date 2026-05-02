#!/usr/bin/env fish

set pictures (xdg-user-dir PICTURES 2>/dev/null)
test -n "$pictures"; or set pictures ~/pictures

set dir $argv[1]
set -q dir[1] || set dir "$pictures/backgrounds"

set cache_dir ~/.cache/walker/backgrounds
mkdir -p $cache_dir

for img in (fd . $dir)
    test -f "$img" || continue

    set thumb "$cache_dir/"(basename "$img")".jpg"
    if not test -e "$thumb"; or test "$img" -nt "$thumb"
        magick "$img" -auto-orient -thumbnail "640x360^" -gravity center -extent "640x360" -strip "$thumb.tmp"
        and mv "$thumb.tmp" "$thumb"
        or rm -f "$thumb.tmp"
    end
end
