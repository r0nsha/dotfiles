source $HOME/.env.fish

# paths
fish_add_path \
    $HOME/.cargo/bin \
    $HOME/.local/bin \
    ./node_modules/.bin \
    $PNPM_HOME \
    ~/.local/share/bob/nvim-bin \
    /opt/homebrew/opt/rustup/bin

source $DOTFILES/.config/fish/functions.fish
source $DOTFILES/.config/fish/aliases.fish
source $DOTFILES/.config/fish/variables.fish

set -l local_config ~/config.fish
if test -r $local_config
    source $local_config
end

if status is-interactive
    set fish_greeting # disable welcome message
    set fish_prompt_pwd_dir_length 1
    set fish_prompt_pwd_full_dirs 2
    fish_vi_key_bindings

    if command -vq zoxide
        zoxide init fish | source
    end
    if command -vq jj
        COMPLETE=fish jj | source
    end
    if command -vq bob
        bob complete fish | source
    end
    if command -vq gopass
        gopass completion fish | source
    end

    function __update_theme --on-event fish_prompt
        switch (ron-theme-get)
            case light
                source $DOTFILES/.config/fish/themes/nor-light.fish
            case '*'
                source $DOTFILES/.config/fish/themes/nor-dark.fish
        end
    end

    if ! functions --query fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        fisher update
    end
end
