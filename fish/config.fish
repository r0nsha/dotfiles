source $HOME/.env.fish

source $DOTFILES/fish/fisher.fish

source $DOTFILES/fish/functions.fish
source $DOTFILES/fish/aliases.fish
source $DOTFILES/fish/vars.fish
source $DOTFILES/fish/macos.fish
fish_config theme choose "Rosé Pine"

# Vi mode
fish_vi_key_bindings

# Disable welcome message
set fish_greeting

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert block
# Set the replace mode cursor to an underscore
set fish_cursor_replace_one block
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block

fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin

# npm
fish_add_path ./node_modules/.bin

# Node stuff
set -Ux NVM_DIR "$HOME/.nvm"

# pnpm
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

    if binary_exists navi
        navi widget fish | source
    end

    if binary_exists atuin
        atuin init fish | source
    end
end
