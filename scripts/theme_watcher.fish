#!/usr/bin/env fish

set -l pidfile ~/.cache/theme_watcher.pid
set -l theme_file ~/.cache/theme

if test -f $pidfile
    set -l pid (cat $pidfile)
    if ps -p $pid >/dev/null 2>/dev/null
        # already running
        exit 0
    end
    # remove stale PID file
    rm -f $pidfile
end

echo $theme_file | entr -p sh -c 'pkill -USR1 fish' >/dev/null 2>&1 </dev/null &
set -l entr_pid $last_pid
echo $entr_pid >$pidfile

disown $entr_pid
