#!/usr/bin/env fish

set -l color_red "#ff5f59"
set -l color_yellow "#d0bc00"
set -l color_green "#44bc44"

set -l active (nmcli -t -f NAME connection show --active | head -n 1)

if test -z "$active"
    set conn "<span color='$color_red'>󰱟 No connection</span>"
else if string match -q "Wired connection*" "$active"
    set conn "<span color='$color_green'>󰲝 Wired</span>"
else
    set -l signal (nmcli -t -f SSID,SIGNAL,ACTIVE dev wifi list | awk -F: -v connection="$active" '$1 == connection && $3 == "yes" {print $2}')
    # based on signal, output the correct nerd font icon
    if test "$signal" -eq 0
        set icon "󰤫"
    else if test "$signal" -le 20
        set icon "󰤠"
    else if test "$signal" -le 45
        set icon "󰤟"
    else if test "$signal" -le 70
        set icon "󰤢"
    else if test "$signal" -le 85
        set icon "󰤥"
    else if test "$signal" -le 100
        set icon "󰖩"
    else
        set icon "󰤫"
    end

    if test "$signal" -le 45
        set color $color_red
    else if test "$signal" -le 70
        set color $color_yellow
    else if test "$signal" -le 100
        set color $color_green
    else
        set color $color_red
    end

    set conn "<span color='$color'>$icon $active</span>"
end

echo " $conn "
