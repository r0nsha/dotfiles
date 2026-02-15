#!/usr/bin/env fish

set -l recorder wf-recorder
set -l pid (pgrep -n "$recorder")

if test -z "$pid"
    exit 0
end

set -l elapsed (ps -p "$pid" -o etimes=)
set -l h (math "floor($elapsed / 3600)")
set -l m (math "floor($elapsed % 3600 / 60)")
set -l s (math "floor($elapsed % 3600 % 60)")

if test "$h" -gt 0
    set time (printf "%d:%02d:%02d" $h $m $s)
else
    set time (printf "%02d:%02d" $m $s)
end

echo "󰻃 $time"
