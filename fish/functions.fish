# @fish-lsp-disable 4004

function binary_exists
    command -v -q $argv[1]
end

function mysk
    sk \
        --bind 'ctrl-y:accept' \
        --no-separator \
        --highlight-line \
        --reverse \
        --info=hidden \
        --pointer=' ' \
        --gutter=' ' \
        $argv
end

function show_colors
    for COLOR in (seq 0 255)
        printf "\e[38;5;%sm%s \e[0m" $COLOR $COLOR
    end
    echo
end

function ssh_server_start
    sudo systemctl enable ssh
    sudo systemctl start ssh
    sudo ufw allow ssh
    sudo ufw enable
    echo ssh server started. run `ssh (whoami)@(hostname -I | awk '{print $1}')` to connect
end

function ssh_server_stop
    sudo systemctl stop ssh
    sudo systemctl disable ssh
    echo ssh server stopped.
end

function get_session_type
    set session_type "$XDG_SESSION_TYPE"

    if test -z "$XDG_SESSION_TYPE"
        set session_type (loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type | sed -E "s/Type=(.*)/\1/")
    end

    echo $session_type
end

function scriptlock
    set -l lockfile $argv[1]

    if test -e "$lockfile"
        set -l pid (cat "$lockfile")

        if ps -p $pid >/dev/null
            echo "Another instance of this script is running (PID $pid). Exiting."
            echo "If you think this is a mistake, remove $lockfile."
            exit 1
        else
            rm -f "$lockfile"
        end
    end

    echo $fish_pid >"$lockfile"

    trap "rm -f \"$lockfile\"; exit 0" INT TERM EXIT
end

function exec-bash
    exec bash -c "source $argv; exec fish"
end

function exec-zsh
    exec zsh -c "source $argv; exec fish"
end

function get_theme
    set -l theme dark

    if test -r $THEME_FILE
        set theme (cat $THEME_FILE)
    end

    if test -z "$theme"
        echo dark
        return
    end

    echo $theme
end

function load-color-vars
    if test -f ~/.cache/wal/colors.fish
        source ~/.cache/wal/colors.fish
    end
end

function get-date
    echo (date +%d-%m-%Y_%Hh%Mm%Ss)
end
