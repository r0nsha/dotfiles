# ALIASES ---------------------------------------------------------------------
alias s 'source $DOTFILES/fish/config.fish'

alias c clear

alias e $EDITOR
alias v nvim
alias vi nvim
alias vim nvim

# sensible defaults
alias cp "cp -ivr"
alias mv "mv -iv"
alias df "df -h"
alias du "du -h"

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

if binary_exists yazi
    alias y yazi
end

if binary_exists neomutt
    alias mutt neomutt
end

# GIT ALIASES -----------------------------------------------------------------
alias gg 'git branch | fzf | xargs git switch'
alias gl "git log --all --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(bold magenta)%d%C(reset)'"
alias gll "git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(green)%an %ar %C(reset) %C(bold magenta)%d%C(reset)'"
alias glc 'git branch | fzf | xargs -I % git log %..HEAD --oneline --decorate --color --graph'
alias glco 'git branch | fzf | xargs -I % git log %..origin/HEAD --oneline --decorate --color --graph'

# PYTHON ALIASES --------------------------------------------------------------
alias python python3
alias pip pip3
