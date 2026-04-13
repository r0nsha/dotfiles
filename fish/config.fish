source $HOME/.env.fish

source $DOTFILES/fish/fisher.fish

source $DOTFILES/fish/functions.fish
source $DOTFILES/fish/aliases.fish
source $DOTFILES/fish/variables.fish

set -l local_config ~/config.fish
if test -r $local_config
    source $local_config
end

set fish_greeting # disable welcome message

# vi mode
fish_vi_key_bindings

# vi: Copy to clipboard in normal mode
bind -M default yy 'commandline -f begin-selection; commandline -f end-selection; fish_clipboard_copy; commandline -f end-selection'
bind -M default Y 'commandline -f begin-selection; commandline -f end-of-line; fish_clipboard_copy; commandline -f end-selection'

# vi: Paste from clipboard in normal and insert mode
bind -M default p fish_clipboard_paste
bind -M insert \cp fish_clipboard_paste

# vi: Visual mode bindings
bind -M visual y 'fish_clipboard_copy; commandline -f end-selection'

# yank/paste with system clipboard
bind yy fish_clipboard_copy
bind Y fish_clipboard_copy
bind p fish_clipboard_paste

# history
bind -M default \cr history-pager
bind -M insert \cr history-pager

# env
set -gx NVM_DIR "$HOME/.nvm"
set -gx PNPM_HOME "$HOME/.local/share/pnpm"

# paths
fish_add_path \
    $HOME/.cargo/bin \
    $HOME/.local/bin \
    ./node_modules/.bin \
    $PNPM_HOME \
    ~/.local/share/bob/nvim-bin \
    /opt/homebrew/opt/rustup/bin

if status is-interactive
    source $DOTFILES/fish/theme.fish

    stty -ixon # disable C-s and C-q

    if binary_exists zoxide
        zoxide init fish | source
    end

    if binary_exists jj
        jj util completion fish >~/.config/fish/completions/jj.fish
    end

    if binary_exists bob
        bob complete fish >~/.config/fish/completions/bob.fish
    end

    # @fish-lsp-disable-next-line 2003
    set -U tide_left_prompt_items pwd character
    # @fish-lsp-disable-next-line 2003 disable right prompt
    set -U tide_right_prompt_items
    # set -U tide_right_prompt_items jj status cmd_duration context jobs direnv bun node python rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig time
end
