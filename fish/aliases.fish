# ALIASES ---------------------------------------------------------------------
abbr -a s 'source ~/.config/fish/config.fish'

abbr -a c clear

abbr -a e $EDITOR
abbr -a v nvim
abbr -a vi nvim
abbr -a vim nvim

# sensible defaults
abbr -a cp "cp -ivr"
abbr -a mv "mv -iv"
abbr -a df "df -h"
abbr -a du "du -h"

# TOOL ALIASES ----------------------------------------------------------------

if binary_exists eza
    abbr -a l eza
    abbr -a ll 'eza -lah'
    abbr -a ls eza
    abbr -a sl eza
end

if binary_exists bat
    abbr -a cat bat
else if binary_exists batcat
    abbr -a cat batcat
else if binary_exists bat
    abbr -a cat bat
end

if binary_exists yazi
    abbr -a y yazi
end

if binary_exists neomutt
    abbr -a mutt neomutt
end

# GIT ALIASES -----------------------------------------------------------------
abbr -a g git
abbr -a gg 'git branch | fzf | xargs git switch'
abbr -a gl "git log --all --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(bold magenta)%d%C(reset)'"
abbr -a gll "git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(green)%an %ar %C(reset) %C(bold magenta)%d%C(reset)'"
abbr -a glc 'git branch | fzf | xargs -I % git log %..HEAD --oneline --decorate --color --graph'
abbr -a glcr 'git branch | fzf | xargs -I % git log %..origin/HEAD --oneline --decorate --color --graph'

# PYTHON ALIASES --------------------------------------------------------------
abbr -a python python3
abbr -a pip pip3
