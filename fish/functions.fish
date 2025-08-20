function warn
    printf "\r\033[2K  [\033[0;33mWARN\033[0m] $argv[1]\n"
end

function source_if_exists
    if test -r $argv[1]
        source $argv[1]
    end
end

function binary_exists
    command -v -q $argv[1]
end

function dashboard
    set -l name dashboard
    tmux new-session -d -s $name
    tmux send-keys -t $name:1.1 "tmux split-window -h -l 35%" enter
    tmux send-keys -t $name:1.1 "tmux clock-mode" enter
    tmux send-keys -t $name:1.1 "tmux split-window -v -l 65%" enter
    tmux send-keys -t $name:1.1 btm enter
    tmux switch-client -t $name
end

function mysk
    sk --color=current_bg:232 $argv
end

function myfzf
    fzf --bind 'ctrl-y:accept' --margin=10% --color=bw $argv
end

function filter_dirs
    for path in $argv
        if test -d $path
            echo $path
        end
    end
end

function tmux_select_dir
    if test (count $argv) -eq 1
        set selected $argv[1]
    else
        set -l search_dirs (
            filter_dirs \
            $HOME/dev \
            $HOME/repos \
            $HOME/dev/core-public/core
        )

        set -l include_dirs (
            filter_dirs \
            $HOME/dotfiles \
            $HOME/notes \
            $HOME/pictures/backgrounds
        )

        set selected (begin
            for dir in $include_dirs
                echo $dir
            end

            fd . $search_dirs --full-path --type d --exact-depth 1
        end | sd "^$HOME/" "" | string trim -r -c / | myfzf)

        # add $HOME back
        set selected $HOME/$selected
    end

    if test -z $selected
        return
    end

    set -l name (basename $selected | tr . _)
    set -l tmux_running (pgrep tmux)

    if test -z $TMUX; and test -z $tmux_running
        tmux new-session -s $name -c "$selected"
        return
    end

    if ! tmux has-session -t $name 2>/dev/null
        tmux new-session -ds $name -c $selected
        tmux select-window -t $name:1 # select first window
    end

    if test -z $TMUX
        tmux attach -t $name
    else
        tmux switch-client -t $name
    end
end

function tmux_select_session
    if test (count $argv) -eq 1
        set selected $argv[1]
    else
        set selected (tmux list-sessions -F "#{session_name}" | myfzf)
    end

    if test -n $selected
        tmux switch-client -t $selected
    end
end

alias t tmux_select_dir
alias td tmux_select_dir
alias ts tmux_select_session

function show_colors
    for COLOR in (seq 0 255)
        printf "\e[38;5;%sm%s \e[0m" $COLOR $COLOR
    end
    echo
end

function zellij_select_dir
    if test (count $argv) -eq 1
        set selected $argv[1]
    else
        set -l search_dirs (
            filter_dirs \
            $HOME/dev \
            $HOME/repos \
            $HOME/dev/core-public/core
        )

        set -l include_dirs (
            filter_dirs \
            $HOME/dotfiles \
            $HOME/notes \
            $HOME/pictures/backgrounds
        )

        set selected (begin
            for dir in $include_dirs
                echo $dir
            end

            fd . $search_dirs --full-path --type d --exact-depth 1
        end | sd "^$HOME/" "" | string trim -r -c / | myfzf)

        # add $HOME back
        set selected $HOME/$selected
    end

    if test -z $selected
        return
    end

    set -l name (basename $selected | tr . _)
    zj attach --create --force-run-commands $name
end

alias zs zellij_select_dir

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
