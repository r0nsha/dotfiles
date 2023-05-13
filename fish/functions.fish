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
    tmux new-session -d -s dashboard
    tmux send-keys -t dashboard:1.1 "tmux split-window -h -l 35%" enter
    tmux send-keys -t dashboard:1.1 "tmux clock-mode" enter
    tmux send-keys -t dashboard:1.1 "tmux split-window -v -l 65%" enter
    tmux send-keys -t dashboard:1.1 "btm" enter
    tmux switch-client -t dashboard
end

function t
	set -l search_dirs $HOME/dev $HOME/dotfiles $HOME/repos

	set -l all_repos (begin
		for path in $search_dirs
			if test -d $path
				fd -uu --type d --full-path '\.git$' $path
			end
		end
	end | xargs dirname)

	echo $all_repos

	set -l repo ($all_repos | xargs -n 1 basename) #| fzf)

	echo repo : $repo

	if test -z $repo
		return
	end

	if [ tmux has-session -t $repo 2>/dev/null ]
		echo create session!
	end

	echo attach session!
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
