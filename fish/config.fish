function source_if_exists
    if test -r $argv[1]
        source $argv[1]
    end
end

# Source bootstrapped environment
bass source $HOME/.env.sh

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

# Alias codelldb
alias codelldb=$HOME/codelldb/extension/adapter/codelldb

# Alias nvim
alias nvim=$HOME/apps/nvim/bin/nvim
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

# Alias python & pip
alias python=python3
alias pip=pip3

# TODO: source_if_exists
source $DOTFILES/fish/aliases.fish

# Theme
source $DOTFILES/fish/kanagawa-theme.fish

# Completions
gh completion -s fish | source
zoxide init fish | source

# Starship
source (/usr/local/bin/starship init fish --print-full-init | psub)
