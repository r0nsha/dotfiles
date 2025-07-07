# ALIASES ---------------------------------------------------------------------
alias s 'source $DOTFILES/fish/config.fish'

alias c clear

alias e $EDITOR
alias v nvim
alias vi nvim
alias vim nvim

alias cp "cp -iv"
alias mv "mv -iv"

alias rmswap 'rm -rf ~/.local/share/nvim/swap'

# TOOL ALIASES ----------------------------------------------------------------

if binary_exists eza
    alias l eza
    alias ll 'eza -lah'
    alias ls eza
    alias sl eza
end

if binary_exists bat
    alias cat bat
else if binary_exists batcat
    alias cat batcat
else if binary_exists bat
    alias cat bat
end

if binary_exists zellij
    alias zj zellij
    alias zrf 'zellij run floating'
end

if binary_exists yabai
    alias yabais 'yabai --start-service'
    alias yabair 'yabai --stop-service && yabai --start-service'
end

if binary_exists skhd
    alias skhds 'skhd --start-service'
    alias skhdr 'skhd --stop-service && skhd --start-service'
end

# GIT ALIASES -----------------------------------------------------------------
alias gg 'git branch | sk | xargs git switch'
alias gl "git log --all --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(bold magenta)%d%C(reset)'"
alias gll "git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(green)%an %ar %C(reset) %C(bold magenta)%d%C(reset)'"
alias glc 'git branch | sk | xargs -I % git log %..HEAD --oneline --decorate --color --graph'
alias glco 'git branch | sk | xargs -I % git log %..origin/HEAD --oneline --decorate --color --graph'

# PYTHON ALIASES --------------------------------------------------------------
alias python python3
alias pip pip3
