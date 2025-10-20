source $HOME/.env.fish

source $DOTFILES/fish/fisher.fish

source $DOTFILES/fish/functions.fish
source $DOTFILES/fish/aliases.fish
source $DOTFILES/fish/variables.fish
source $DOTFILES/fish/macos.fish

set -l local_config ~/config.fish
if test -r $local_config
    source $local_config
end

function update_theme --on-variable COLORS_CHANGED
    set -l colors_file ~/.cache/wal/colors.fish
    if test -r $colors_file
        source $colors_file
    else if test "$THEME" = light
        source $DOTFILES/fish/themes/modus_operandi.fish
    else
        source $DOTFILES/fish/themes/modus_vivendi.fish
    end
end

update_theme

set fish_greeting # disable welcome message
fish_vi_key_bindings

# yank/paste with system clipboard
bind yy fish_clipboard_copy
bind Y fish_clipboard_copy
bind p fish_clipboard_paste

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

# tide prompt
set -g tide_cmd_duration_decimals 0

if status is-interactive
    stty -ixon # disable C-s and C-q

    # Zoxide
    if binary_exists zoxide
        zoxide init fish | source
    end

    if binary_exists mcfly
        set -gx MCFLY_KEY_SCHEME vim
        set -gx MCFLY_FUZZY 2
        set -gx MCFLY_INTERFACE_VIEW TOP
        set -gx MCFLY_DISABLE_MENU TRUE
        set -gx MCFLY_PROMPT ">"
        mcfly init fish | source
    end

    if binary_exists jj
        jj util completion fish | source
    end
end
