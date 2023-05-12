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
	set -l repo (begin
		for path in $HOME/dev $HOME/dotfiles $HOME/repos
			if test -d $path
				fd -uu --type d --full-path '\.git$' $path
			end
		end
	end | xargs dirname | xargs -n 1 basename | fzf)

	echo $repo
end
