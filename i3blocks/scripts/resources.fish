#!/usr/bin/env fish

set cpu_usage (top -bn1 | rg "Cpu\(s\)" | awk '{ if ($2 == 0.0) { print "0" } else { printf "%.1f\n", $2 } }')
set ram_usage (free -m | awk 'NR==2{printf "%.1f", $3*100/$2 }')
set swap_usage (free -m | awk 'NR==3{printf "%.1f", $3*100/$2 }')
echo " 󰓅 $cpu_usage%  $ram_usage%  $swap_usage% "
