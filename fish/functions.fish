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

function t
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
		$HOME/neorg
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

    set -l selected_name (basename $selected | tr . _)
    set -l tmux_running (pgrep tmux)

    if test -z $TMUX && test -z $tmux_running
        tmux new-session -s $selected_name -c $selected
        return
    end

    if ! tmux has-session -t $selected_name 2>/dev/null
        tmux new-session -ds $selected_name -c $selected
        tmux select-window -t $selected_name:1
    end

    tmux switch-client -t $selected_name
end

function cht
    set -l cht_url "https://cht.sh"
    set -l cht_list $DOTFILES/fish/cht_list

    set -l selected (cat --plain $cht_list | fzf)

    if test -z $selected
        return
    end

    echo Selected: $selected

    read --prompt "echo 'Query: ' " -l query
    set -l query (echo $query | tr ' ' '+')

    set -l url (
	if test -z $query
	    echo $cht_url/$selected
	else
	    echo $cht_url/$selected/$query
	end
    )

    tmux neww fish -c "curl $url | cat --style auto & while [ : ]; sleep 1; end"
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
