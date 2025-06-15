# ALIASES ---------------------------------------------------------------------
alias s 'source $DOTFILES/fish/config.fish'

alias v nvim
alias vi nvim
alias vim nvim

alias c clear

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
    alias zrf zellij run floating
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
alias gc 'git commit'
alias gch 'git checkout'
alias ga 'git add'
alias gb 'git branch'
alias gd 'git diff -w'
alias gr 'git restore'
alias gst 'git rev-parse --git-dir > /dev/null 2>&1 && git status || eza'
alias gu 'git reset --soft HEAD~1'
alias gpr 'git remote prune origin'
alias ff 'gpr && git pull --ff-only'
alias grd 'git fetch origin && git rebase origin/master'
alias gbb git-switchbranch
alias gbf 'git branch | head -1 | xargs' # top branch
alias gla "git log --all --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(bold magenta)%d%C(reset)'"
alias glv "git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(green)%an %ar %C(reset) %C(bold magenta)%d%C(reset)'"
alias glc 'git branch | sk | xargs -I % git log %..HEAD --oneline --decorate --color --graph'
alias glco 'git branch | sk | xargs -I % git log %..origin/HEAD --oneline --decorate --color --graph'

alias gp "git push -u 2>&1 | tee >(cat) | grep \"pull/new\" | awk '{print \$2}' | xargs open"

alias gg 'git branch | sk | xargs git checkout'
alias gup 'git branch --set-upstream-to=origin/(git-current-branch) (git-current-branch)'

# PYTHON ALIASES --------------------------------------------------------------
alias python python3
alias pip pip3

# MISC ALIASES ----------------------------------------------------------------
alias codelldb $HOME/codelldb/extension/adapter/codelldb
