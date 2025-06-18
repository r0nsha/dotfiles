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

        set -l perm_dirs (
	    filter_dirs \
		$HOME/dotfiles \
		$HOME/notes
	)

        set selected (begin
	    for dir in $perm_dirs
		echo $dir
	    end

	    fd . $search_dirs --full-path --type d --min-depth 1 --max-depth 1
	end | sed "s|^$HOME/||" | sk)

        # add $HOME back
        set selected $HOME/$selected
    end

    if test -z $selected
        return
    end

    set -l name (basename $selected | tr . _)

    if ! tmux has-session -t $name 2>/dev/null
        tmux new-session -ds $name -c $selected
        tmux select-window -t $name:1
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
        set selected (tmux list-sessions -F "#{session_name}" | sk)
    end

    if test -n $selected
        tmux switch-client -t $selected
    end
end

alias t tmux_select_dir
alias td tmux_select_dir
alias ts tmux_select_session

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function show_colors
    for COLOR in (seq 0 255)
        printf "\e[38;5;%sm%s \e[0m" $COLOR $COLOR
    end
    echo
end

function _search_history
    printf '\e7'
    set -l selected_command (history | sk --reverse --tac --no-sort)
    printf '\e8'
    if test -n "$selected_command"
        commandline -- $selected_command
    end
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

        set -l perm_dirs (
            filter_dirs \
            $HOME/dotfiles \
            $HOME/notes
        )

        set selected (begin
            for dir in $perm_dirs
                echo $dir
            end

            fd . $search_dirs --full-path --type d --min-depth 1 --max-depth 1
        end | sed "s|^$HOME/||" | sk)

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
