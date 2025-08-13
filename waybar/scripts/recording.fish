#!/usr/bin/env fish

set recorder wf-recorder

function recorder_pids
    ps -ef | rg screen.fish | awk '{print $2}' | xargs -I {} pgrep -P {} $recorder
end

while true
    echo ""

    set pids ""
    while true
        set -g pids "$(recorder_pids)"
        if test -n "$pids"
            break
        end
        sleep 1
    end

    set -l start_time (ps -p $pids[1] -o lstart=)
    set -l start_epoch (date -d "$start_time" +%s)

    while test -n "$(recorder_pids)"
        set -l now_epoch (date +%s)
        set -l elapsed (math "$now_epoch - $start_epoch")
        set -l h (math "floor($elapsed / 3600)")
        set -l m (math "floor($elapsed % 3600 / 60)")
        set -l s (math "floor($elapsed % 3600 % 60)")

        if test "$h" -gt 0
            set time (printf "%d:%02d:%02d" $h $m $s)
        else
            set time (printf "%02d:%02d" $m $s)
        end

        echo "󰻃 $time"

        sleep 1
    end

    pidwait $recorder
end
