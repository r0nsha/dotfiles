#!/usr/bin/env fish

set cache_dir ~/.cache/pass-menu

function notify_error
    notify-send pass "$argv[1]"
end

set session_type

function setup_backends
    if command -q ron-login-session-type
        set session_type (ron-login-session-type)
    else if set -q WAYLAND_DISPLAY
        set session_type wayland
    else if set -q DISPLAY
        set session_type x11
    else
        notify_error "Unknown display server"
        return 1
    end
end

function store_last_used
    mkdir -p $cache_dir
    printf %s $argv[1] >$cache_dir/last_used
end

function copy_to_clipboard
    set -l text $argv[1]

    switch $session_type
        case x11
            printf %s "$text" | xclip -sel clip
        case wayland
            printf %s "$text" | wl-copy
    end
end

function type_text
    set -l text $argv[1]

    switch $session_type
        case x11
            xdotool type --delay 0 --clearmodifiers -- "$text"
        case wayland
            wtype "$text"
    end
end

function password_contents
    set -l entry $argv[1]
    gopass show "$entry" | string collect
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

function find_field
    set -l contents $argv[1]
    set -l pattern $argv[2]

    for line in (string split \n -- $contents)
        set -l parts (string split -m 1 ":" -- $line)
        if string match -qr $pattern -- $parts[1]
            string trim -- $parts[2]
            return
        end
    end

    return 1
end

function resolve_value
    set -l target $argv[1]
    set -l contents $argv[2]
    set -l entry $argv[3]

    if test "$target" = otp
        gopass otp -o "$entry" 2>/dev/null
    else
        field_value "$contents" "$target"
    end
end

function autotype
    set -l contents $argv[1]
    set -l password (field_value "$contents" pass)
    set -l user (find_field "$contents" '^user')
    set -l email (find_field "$contents" '^(e-?)?mail$')

    if test -n "$user"
        set id $user
    else if test -n "$email"
        set id $email
    else
        notify_error "Can't autotype because no user or email is set"
        return 1
    end

    switch $session_type
        case x11
            xdotool type --delay 0 --clearmodifiers -- "$id"
            sleep 0.1
            xdotool key --clearmodifiers Tab
            sleep 0.1
            xdotool type --delay 0 --clearmodifiers -- "$password"
        case wayland
            wtype "$id"
            sleep 0.1
            wtype -P Tab -p Tab
            sleep 0.1
            wtype "$password"
            sleep 0.1
            wtype -P Return -p Return
    end
end

set action $argv[1]
set target $argv[2]
set entry $argv[3]

if test -z "$action"; or test -z "$entry"
    notify_error "Usage: pass.fish <copy|type|autotype> <target> <entry>"
    exit 1
end

setup_backends || exit 1
store_last_used "$entry"

set -l contents
if test "$target" != otp
    set contents (password_contents "$entry")
    if test $status -ne 0 -o -z "$contents"
        notify_error "Could not read $entry"
        exit 1
    end
end

switch $action
    case copy
        set -l value (resolve_value "$target" "$contents" "$entry")
        if test -z "$value"
            notify_error "No $target field for $entry"
            exit 1
        end

        copy_to_clipboard "$value"
        notify-send "Copied $target to clipboard"
    case type
        set -l value (resolve_value "$target" "$contents" "$entry")
        if test -z "$value"
            notify_error "No $target field for $entry"
            exit 1
        end

        type_text "$value"
    case autotype
        autotype "$contents"
    case '*'
        notify_error "Unknown action: $action"
        exit 1
end

