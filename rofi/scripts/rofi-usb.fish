#!/usr/bin/env fish

# A rofi menu for selecting udisks devices using udiskie

set -l options (
    for device in (udiskie-info -a)
        set -l label (udiskie-info $device -o "󰕓 {device_file} | {drive_label} {ui_id_uuid}")
        if test (udiskie-info $device -o "{is_mounted}") = True
            set label "$label (Mounted)"
        end
        echo $label
    end | sort | string join "\n"
)
set -l picked (echo -e $options | rofi -dmenu -p "USB Devices" -theme-str "window {width: 20%;}")
set -l device (echo $picked | awk '{print $2}')

if test -z "$device"
    exit
end

if mount | rg -q "$device"
    udiskie-umount "$device"
else
    udiskie-mount "$device"
end
