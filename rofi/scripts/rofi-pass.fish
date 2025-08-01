#!/usr/bin/env fish

# TODO: autotype
# TODO: email
# TODO: pass
# TODO: user
# TODO: copy with ctrl-c
# TODO: show last
# TODO: insert new pass

set pass_dir ~/.password-store

set session_type "$XDG_SESSION_TYPE"

if test -z "$XDG_SESSION_TYPE"
    set session_type (loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type | sed -E "s/Type=(.*)/\1/")
end

if test "$session_type" = wayland
    set clip_backend wl-copy
    set type_backend wtype
else if test "$session_type" = x11
    set clip_backend xclip
    set type_backend xdotool
else
    notify-send "Unknown display server: $session_type"
    exit 1
end

function copy_to_clipboard
    set -l text $argv[1]
    switch $clip_backend
        case xclip
            echo -n $text | xclip -sel clip
        case wl-copy
            echo -n $text | wl-copy
    end
end

function list_all
    set -l passwords (fd .gpg $pass_dir | sed -E "s|$pass_dir\/(.*)\.gpg|\\1|" | sort | string join "\n")
    set -l picked (
        echo -e $passwords \
        | rofi -dmenu -p Pass \
            -mesg "enter Pick | alt-o Show&#x0a;alt-p Copy pass | alt-e Copy email | alt-u Copy user" \
            -kb-custom-1 "alt-o" \
            -kb-custom-2 "alt-p" \
            -kb-custom-3 "alt-e" \
            -kb-custom-4 "alt-u"
    )
    set -l rofi_exit $status

    if test -z "$picked"
        return
    end

    switch $rofi_exit
        case 0 # enter
            dunstify enter
        case 10 # alt-o
            show $picked
        case 11 # alt-p
            copy_target $picked pass
        case 12 # alt-e
            copy_target $picked email
        case 13 # alt-u
            copy_target $picked user
    end
end

function show
    set -l password $argv[1]
    set -l options "󰅁 Return\npass: $(pass show $password)"
    set -l picked (echo -e $options | rofi -dmenu -p $password)

    if test -z "$picked"
        return
    end

    if string match -q "*Return" $picked
        list_all
        return
    end

    set -l parts (string split ": " $picked)
    copy_to_clipboard $parts[2]
    notify-send "Copied $parts[1] to clipboard"
end

function copy_target
    set -l password $argv[1]
    set -l target $argv[2]
    set -l contents (pass show $password | string join "\n")

    # find $target in $contents
    if test "$target" = pass
        set target_contents (echo -e $contents | head -n1)
    else
        set target_contents (echo -e $contents | rg $target)
        set -l parts (string split ": " $target_contents)
        set target_contents $parts[2]
    end

    copy_to_clipboard $target_contents
    notify-send "Copied $target to clipboard"
end

list_all
