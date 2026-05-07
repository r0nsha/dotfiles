# @fish-lsp-disable 4004

function exec-bash
    exec bash -c "source $argv; exec fish"
end

function exec-zsh
    exec zsh -c "source $argv; exec fish"
end

function load-color-vars
    if test -f ~/.cache/hellwal/colors.fish
        source ~/.cache/hellwal/colors.fish
    end
end

function get-date
    echo (date +%d-%m-%Y_%Hh%Mm%Ss)
end
