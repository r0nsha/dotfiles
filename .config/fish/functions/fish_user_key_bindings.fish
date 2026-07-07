function fish_user_key_bindings
    # yank
    bind -M default yy 'commandline -f begin-selection; commandline -f end-selection; fish_clipboard_copy; commandline -f end-selection'
    bind -M default Y 'commandline -f begin-selection; commandline -f end-of-line; fish_clipboard_copy; commandline -f end-selection'
    bind -M visual y 'fish_clipboard_copy; commandline -f end-selection'

    # paste
    bind -M default p fish_clipboard_paste
    bind -M insert \cp fish_clipboard_paste

    # yank/paste with system clipboard
    bind yy fish_clipboard_copy
    bind Y fish_clipboard_copy
    bind p fish_clipboard_paste

    # history
    bind -M default \cr history-pager
    bind -M insert \cr history-pager
    # bind -M normal \cp history-search-backward
    # bind -M insert \cp history-search-backward
    # bind -M normal \cn history-search-forward
    # bind -M insert \cn history-search-forward

    # prevent ctrl-d from exiting the shell
    bind --preset -e ctrl-d
    bind --preset -M insert -e ctrl-d
    bind --preset -M visual -e ctrl-d

    # complete paths with sk
    function __sk_path_widget
        set -l sel (fd --type d --type f --hidden --exclude .git 2>/dev/null \
        | sk --ansi -m --preview 'bat --color=always {} 2>/dev/null || cat {} 2>/dev/null' --preview-window right:50%)
        if test -n "$sel"
            commandline -i -- (string escape -- $sel)
        end
        commandline -f repaint
    end

    bind -M default \ct __sk_path_widget
    bind -M insert \ct __sk_path_widget
    bind -M normal \ct __sk_path_widget
end
