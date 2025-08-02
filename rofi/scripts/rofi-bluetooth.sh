#!/usr/bin/env bash

# TODO: convert to fish

#             __ _       _     _            _              _   _
#  _ __ ___  / _(_)     | |__ | |_   _  ___| |_ ___   ___ | |_| |__
# | '__/ _ \| |_| |_____| '_ \| | | | |/ _ \ __/ _ \ / _ \| __| '_ \
# | | | (_) |  _| |_____| |_) | | |_| |  __/ || (_) | (_) | |_| | | |
# |_|  \___/|_| |_|     |_.__/|_|\__,_|\___|\__\___/ \___/ \__|_| |_|
#
# Author: Nick Clyde (clydedroid)
#
# A script that generates a rofi menu that uses bluetoothctl to
# connect to bluetooth devices and display status info.
#
# Inspired by networkmanager-dmenu (https://github.com/firecat53/networkmanager-dmenu)
# Thanks to x70b1 (https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/system-bluetooth-bluetoothctl)
#
# Depends on:
#   Arch repositories: rofi, bluez-utils (contains bluetoothctl), bc

# Constants
divider="---------"
goback="Back"

_notify() {
    dunstify -r 42 -t 2000 -u low "$1"
}

# Checks if bluetooth controller is powered on
power_on() {
    if bluetoothctl show | rg -q "Powered: yes"; then
        return 0
    else
        return 1
    fi
}

# Toggles power state
toggle_power() {
    if power_on; then
        bluetoothctl power off
        show_menu
    else
        if rfkill list bluetooth | rg -q 'blocked: yes'; then
            rfkill unblock bluetooth && sleep 3
        fi
        bluetoothctl power on
        show_menu
    fi
}

# Checks if controller is scanning for new devices
scan_on() {
    if bluetoothctl show | rg -q "Discovering: yes"; then
        echo "Scan: on"
        return 0
    else
        echo "Scan: off"
        return 1
    fi
}

# Toggles scanning state
toggle_scan() {
    if scan_on; then
        kill $(pgrep -f "bluetoothctl --timeout 5 scan on")
        bluetoothctl scan off
        show_menu
    else
        bluetoothctl --timeout 5 scan on
        echo "Scanning..."
        show_menu
    fi
}

# Checks if controller is able to pair to devices
pairable_on() {
    if bluetoothctl show | rg -q "Pairable: yes"; then
        echo "Pairable: on"
        return 0
    else
        echo "Pairable: off"
        return 1
    fi
}

# Toggles pairable state
toggle_pairable() {
    if pairable_on; then
        bluetoothctl pairable off
        show_menu
    else
        bluetoothctl pairable on
        show_menu
    fi
}

# Checks if controller is discoverable by other devices
discoverable_on() {
    if bluetoothctl show | rg -q "Discoverable: yes"; then
        echo "Discoverable: on"
        return 0
    else
        echo "Discoverable: off"
        return 1
    fi
}

# Toggles discoverable state
toggle_discoverable() {
    if discoverable_on; then
        bluetoothctl discoverable off
        show_menu
    else
        bluetoothctl discoverable on
        show_menu
    fi
}

# Checks if a device is connected
device_connected() {
    device_info=$(bluetoothctl info "$1")
    if echo "$device_info" | rg -q "Connected: yes"; then
        return 0
    else
        return 1
    fi
}

# Toggles device connection
toggle_connection() {
    local mac="$1"
    local device_name="$2"
    if device_connected "$mac"; then
        _notify "Disconnecting from $device_name"
        bluetoothctl disconnect "$mac"
        _notify "Disconnected from $device_name"
        device_menu "$device"
    else
        _notify "Connecting to $device_name"
        bluetoothctl connect "$mac"
        _notify "Connected to $device_name"
        device_menu "$device"
    fi
}

# Checks if a device is paired
device_paired() {
    device_info=$(bluetoothctl info "$1")
    if echo "$device_info" | rg -q "Paired: yes"; then
        echo "Paired: yes"
        return 0
    else
        echo "Paired: no"
        return 1
    fi
}

# Toggles device paired state
toggle_paired() {
    local mac="$1"
    local device_name="$2"
    if device_paired "$mac"; then
        _notify "Removing $device_name from pairing"
        bluetoothctl remove "$mac"
        _notify "Removed $device_name from pairing"
        device_menu "$device"
    else
        _notify "Pairing with $device_name"
        bluetoothctl pair "$mac"
        _notify "Paired with $device_name"
        device_menu "$device"
    fi
}

# Checks if a device is trusted
device_trusted() {
    device_info=$(bluetoothctl info "$1")
    if echo "$device_info" | rg -q "Trusted: yes"; then
        echo "Trusted: yes"
        return 0
    else
        echo "Trusted: no"
        return 1
    fi
}

# Toggles device connection
toggle_trust() {
    local mac="$1"
    local device_name="$2"
    if device_trusted $mac; then
        _notify "Untrusting $device_name"
        bluetoothctl untrust $mac
        _notify "Untrusted $device_name"
        device_menu "$device"
    else
        _notify "Trusting $device_name"
        bluetoothctl trust $mac
        _notify "Trusted $device_name"
        device_menu "$device"
    fi
}

# Prints a short string with the current bluetooth status
# Useful for status bars like polybar, etc.
print_status() {
    if power_on; then
        printf ''

        paired_devices_cmd="devices Paired"
        # Check if an outdated version of bluetoothctl is used to preserve backwards compatibility
        if (($(echo "$(bluetoothctl version | cut -d ' ' -f 2) < 5.65" | bc -l))); then
            paired_devices_cmd="paired-devices"
        fi

        mapfile -t paired_devices < <(bluetoothctl $paired_devices_cmd | rg Device | cut -d ' ' -f 2)
        counter=0

        for device in "${paired_devices[@]}"; do
            if device_connected "$device"; then
                device_alias=$(bluetoothctl info "$device" | rg "Alias" | cut -d ' ' -f 2-)

                if [ $counter -gt 0 ]; then
                    printf ", %s" "$device_alias"
                else
                    printf " %s" "$device_alias"
                fi

                ((counter++))
            fi
        done
        printf "\n"
    else
        echo ""
    fi
}

# A submenu for a specific device that allows connecting, pairing, and trusting
device_menu() {
    device=$1

    # Get device name and mac address
    device_name=$(echo "$device" | cut -d ' ' -f 3-)
    mac=$(echo "$device" | cut -d ' ' -f 2)

    # Build options
    if device_connected "$mac"; then
        connected="Connected: yes"
    else
        connected="Connected: no"
    fi
    paired=$(device_paired "$mac")
    trusted=$(device_trusted "$mac")
    options="$connected\n$paired\n$trusted\n$divider\n$goback\nExit"

    # Open rofi menu, read chosen option
    chosen="$(echo -e "$options" | $rofi_command "$device_name")"

    # Match chosen option to command
    case "$chosen" in
    "" | "$divider")
        echo "No option chosen."
        ;;
    "$connected")
        toggle_connection "$mac" "$device_name"
        ;;
    "$paired")
        toggle_paired "$mac" "$device_name"
        ;;
    "$trusted")
        toggle_trust "$mac" "$device_name"
        ;;
    "$goback")
        show_menu
        ;;
    esac
}

# Opens a rofi menu with current bluetooth status and options to connect
show_menu() {
    # Get menu options
    if power_on; then
        power="Power: on"

        all_devices=$(bluetoothctl devices)
        # Human-readable names of devices, one per line
        # If scan is off, will only list paired devices
        _devices=$(echo "$all_devices" | rg Device | cut -d ' ' -f 3-)
        devices=()
        for device in $_devices; do
            _mac=$(echo "$all_devices" | rg "$device" | cut -d ' ' -f 2)
            if device_connected "$_mac"; then
                devices+=("󰂯 $device (Connected)")
            else
                devices+=("󰂲 $device")
            fi
        done

        # Get controller flags
        scan=$(scan_on)
        pairable=$(pairable_on)
        discoverable=$(discoverable_on)

        # Options passed to rofi
        options="$devices\n$divider\n$power\n$scan\n$pairable\n$discoverable\nExit"
    else
        power="Power: off"
        options="$power\nExit"
    fi

    # Open rofi menu, read chosen option
    chosen="$(echo -e "$options" | $rofi_command "Bluetooth")"
    chosen=$(echo "$chosen" | cut -d ' ' -f 2)

    # Match chosen option to command
    case "$chosen" in
    "" | "$divider")
        echo "No option chosen."
        ;;
    "$power")
        toggle_power
        ;;
    "$scan")
        toggle_scan
        ;;
    "$discoverable")
        toggle_discoverable
        ;;
    "$pairable")
        toggle_pairable
        ;;
    *)
        device=$(echo "$all_devices" | rg "$chosen")
        # Open a submenu if a device is selected
        if [[ $device ]]; then device_menu "$device"; fi
        ;;
    esac
}

# Rofi command to pipe into, can add any options here
rofi_command="rofi -dmenu $* -p"

case "$1" in
--status)
    print_status
    ;;
*)
    show_menu
    ;;
esac
