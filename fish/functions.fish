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
    tmux send-keys -t $name:1.1 "btm" enter
    tmux switch-client -t $name
end

function t
    set -l search_dirs $HOME/dev $HOME/dotfiles $HOME/repos

    set -l all_repos (begin
	for path in $search_dirs
	    if test -d $path
		fd -uu --type d --full-path --max-depth 2 '\.git$' $path
	    end
	end
    end | xargs dirname)

    set -l repo (echo $all_repos | tr ' ' '\n' | fzf)

    if test -z $repo
	return
    end

    set -l name (basename $repo)

    if ! tmux has-session -t $name 2>/dev/null
	tmux new-session -d -s $name -c $repo
    end

    if test -z $TMUX
	tmux attach -t $name
    else
	tmux switch-client -t $name
    end
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
