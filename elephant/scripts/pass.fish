#!/usr/bin/env fish

set -g cache_dir ~/.cache/pass-menu

function notify_error
    notify-send pass "$argv[1]"
end

function setup_backends
    if command -q ron-login-session-type
        set -g session_type (ron-login-session-type)
    else if set -q WAYLAND_DISPLAY
        set -g session_type wayland
    else if set -q DISPLAY
        set -g session_type x11
    else
        notify_error "Unknown display server"
        return 1
    end

    switch $session_type
        case wayland
            set -g clip_backend wl-copy
            set -g type_backend wtype
        case x11
            set -g clip_backend xclip
            set -g type_backend xdotool
        case '*'
            notify_error "Unknown display server: $session_type"
            return 1
    end
end

function store_last_used
    mkdir -p $cache_dir
    printf %s $argv[1] >$cache_dir/last_used
end

function copy_to_clipboard
    set -l text $argv[1]

    switch $clip_backend
        case xclip
            printf %s "$text" | xclip -sel clip
        case wl-copy
            printf %s "$text" | wl-copy
    end
end

function type_text
    set -l text $argv[1]

    switch $type_backend
        case xdotool
            xdotool type --delay 0 --clearmodifiers -- "$text"
        case wtype
            wtype "$text"
    end
end

function password_contents
    set -l password $argv[1]
    command gopass show "$password" | string collect
end

function field_value
    set -l contents $argv[1]
    set -l target $argv[2]

    if test "$target" = pass
        set -l lines (string split \n -- $contents)
        printf %s $lines[1]
        return
    end

    for line in (string split \n -- $contents)
        set -l parts (string split -m 1 ":" -- $line)
        if test "$parts[1]" = "$target"
            string trim -- $parts[2]
            return
        end
    end

    return 1
end

function user_field_value
    set -l contents $argv[1]

    for line in (string split \n -- $contents)
        set -l parts (string split -m 1 ":" -- $line)
        if string match -qr '^user' -- $parts[1]
            string trim -- $parts[2]
            return
        end
    end

    return 1
end

function email_field_value
    set -l contents $argv[1]

    for line in (string split \n -- $contents)
        set -l parts (string split -m 1 ":" -- $line)
        if string match -qr '^(e-?)?mail$' -- $parts[1]
            string trim -- $parts[2]
            return
        end
    end

    return 1
end

function autotype
    set -l contents $argv[1]
    set -l pass (field_value "$contents" pass)
    set -l user (user_field_value "$contents")
    set -l email (email_field_value "$contents")

    if test -n "$user"
        set id $user
    else if test -n "$email"
        set id $email
    else
        notify_error "Can't autotype because no user or email is set"
        return 1
    end

    switch $type_backend
        case xdotool
            xdotool type --delay 0 --clearmodifiers -- "$id"
            sleep 0.1
            xdotool key --clearmodifiers Tab
            sleep 0.1
            xdotool type --delay 0 --clearmodifiers -- "$pass"
        case wtype
            wtype "$id"
            sleep 0.1
            wtype -P Tab -p Tab
            sleep 0.1
            wtype "$pass"
            sleep 0.1
            wtype -P Return -p Return
    end
end

set action $argv[1]
set target $argv[2]
set password $argv[3]

if test -z "$action"; or test -z "$password"
    notify_error "Usage: pass.fish <copy|type|autotype> <target> <password>"
    exit 1
end

setup_backends || exit 1
store_last_used "$password"

set -l contents (password_contents "$password")
if test $status -ne 0 -o -z "$contents"
    notify_error "Could not read $password"
    exit 1
end

switch $action
    case copy
        if test "$target" = otp
            set value (gopass otp -o "$password" 2>/dev/null)
        else
            set value (field_value "$contents" "$target")
        end

        if test -z "$value"
            notify_error "No $target field for $password"
            exit 1
        end

        copy_to_clipboard "$value"
        notify-send "Copied $target to clipboard"
    case type
        if test "$target" = otp
            set value (gopass otp -o "$password" 2>/dev/null)
        else
            set value (field_value "$contents" "$target")
        end

        if test -z "$value"
            notify_error "No $target field for $password"
            exit 1
        end

        type_text "$value"
    case autotype
        autotype "$contents"
    case '*'
        notify_error "Unknown action: $action"
        exit 1
end
