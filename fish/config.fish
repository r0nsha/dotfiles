# Source bootstrapped environment
bass source $HOME/.env.sh

source_if_exists $DOTFILES/fish/functions.fish

# Vi mode
fish_vi_key_bindings

# Disable welcome message
set fish_greeting

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert line
# Set the replace mode cursor to an underscore
set fish_cursor_replace_one underscore
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block

# Set nvim as my default editor
set -Ux VISUAL nvim
set -Ux EDITOR nvim

# Set lang to UTF-8
set -Ux LANGUAGE en_US.UTF-8
set -Ux LC_ALL en_US.UTF-8
set -Ux LANG en_US.UTF-8
set -Ux LC_TYPE en_US.UTF-8

# Rust stuff
bass source $HOME/.cargo/env
fish_add_path $HOME/.local/bin

# Node stuff
set -Ux NVM_DIR "$HOME/.nvm"

source_if_exists $DOTFILES/fish/aliases.fish
source_if_exists $DOTFILES/fish/kanagawa-theme.fish

# Optional local config
source_if_exists $HOME/local.config.fish

ensure_tools

# Completions
if binary_exists gh
    gh completion -s fish | source
end

if binary_exists zoxide
    zoxide init fish | source
end
    
# Starship
if binary_exists starship
    source (starship init fish --print-full-init | psub)
end
