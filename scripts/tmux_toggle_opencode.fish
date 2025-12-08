set current (tmux display-message -p '#W')
if test "$current" = opencode
    tmux last-window
else
    if tmux list-windows | grep -q opencode
        tmux select-window -t opencode
    else
        tmux new-window -n opencode opencode
    end
end
