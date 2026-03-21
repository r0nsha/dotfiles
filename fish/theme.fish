function apply_theme
    set -l theme (get_theme)

    switch $theme
        case light
            source $DOTFILES/fish/themes/modus_operandi.fish
        case '*'
            source $DOTFILES/fish/themes/modus_vivendi.fish
    end
end

function update_theme --on-signal USR1
    apply_theme
end

apply_theme
