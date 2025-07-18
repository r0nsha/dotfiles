source $HOME/.env.fish

source $DOTFILES/fish/fisher.fish

source $DOTFILES/fish/functions.fish
source $DOTFILES/fish/aliases.fish
source $DOTFILES/fish/vars.fish
source $DOTFILES/fish/macos.fish
source $DOTFILES/fish/themes/modus_vivendi.fish

stty -ixon # disable C-s and C-q

set fish_greeting # disable welcome message
fish_vi_key_bindings

# cursor
set fish_cursor_default block
set fish_cursor_insert block
set fish_cursor_replace_one block
set fish_cursor_visual block

# paths
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path ./node_modules/.bin
set -Ux NVM_DIR "$HOME/.nvm"
set -Ux PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path $PNPM_HOME

if status is-interactive
    # Zoxide
    if binary_exists zoxide
        zoxide init fish | source
    end

    # Starship
    if binary_exists starship
        function starship_transient_prompt_func
            starship module character
        end

        function starship_transient_rprompt_func
            starship module time
        end

        starship init fish | source
        enable_transience
    end

    if binary_exists mcfly
        set -gx MCFLY_KEY_SCHEME vim
        set -gx MCFLY_FUZZY 2
        set -gx MCFLY_INTERFACE_VIEW TOP
        set -gx MCFLY_DISABLE_MENU TRUE
        set -gx MCFLY_PROMPT ">"
        mcfly init fish | source
    end
end
