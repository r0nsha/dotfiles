#!/usr/bin/env fish

# A rofi menu for killing processes

set lines (string split -n \n -- "$(ps -eo comm,cmd,%cpu,%mem,pid)")
set header "$(string trim $lines[1])"
set processes $lines[2..]
set picked (printf "%s\n" $processes | rofi -dmenu -p "kill" -mesg "enter Kill | c-enter Kill All&#x0a;$header" -kb-accept-custom "" -kb-custom-1 "control+Return")
set _status $status

if test -z "$picked"
    exit
end

if test "$_status" = 10
    set comm (echo $picked | awk '{print $1}')
    killall $comm
else
    set pid (echo $picked | awk '{print $NF}')
    kill -15 $pid
end
