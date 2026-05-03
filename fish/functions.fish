# @fish-lsp-disable 4004

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

function exec-bash
    exec bash -c "source $argv; exec fish"
end

function exec-zsh
    exec zsh -c "source $argv; exec fish"
end

function load-color-vars
    if test -f ~/.cache/wal/colors.fish
        source ~/.cache/wal/colors.fish
    end
end

function get-date
    echo (date +%d-%m-%Y_%Hh%Mm%Ss)
end
