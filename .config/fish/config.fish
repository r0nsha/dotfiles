# paths
fish_add_path \
    $HOME/.cargo/bin \
    $HOME/.local/bin \
    ./node_modules/.bin \
    $PNPM_HOME \
    ~/.local/share/bob/nvim-bin \
    /opt/homebrew/opt/rustup/bin

set config_dir (status dirname)
source "$config_dir/functions.fish"
source "$config_dir/aliases.fish"
source "$config_dir/variables.fish"

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

    function __update_theme --on-event fish_prompt
        switch (ron-theme-get)
            case light
                source "$config_dir/themes/nor-light.fish"
            case '*'
                source "$config_dir/themes/nor-dark.fish"
        end
    end

    if ! functions --query fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        fisher update
    end
end
