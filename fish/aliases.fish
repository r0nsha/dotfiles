# ALIASES
abbr -a s 'source ~/.config/fish/config.fish'

abbr -a c clear
abbr -a o open

abbr -a e $EDITOR
abbr -a v nvim
abbr -a vi nvim
abbr -a vim nvim

# sensible defaults
abbr -a cp "cp -ivr"
abbr -a mv "mv -iv"
abbr -a df "df -h"
abbr -a du "du -h"

# TOOL ALIASES

if command -vq eza
    abbr -a l eza
    abbr -a ls eza
    abbr -a ll 'eza -lh'
    abbr -a lll 'eza -lah'
    abbr -a lt 'eza -T'
    abbr -a llt 'eza -lhT'
    abbr -a lllt 'eza -lahT'
else
    abbr -a l ls
    abbr -a ll 'ls -lh'
    abbr -a lll 'ls -lah'
    abbr -a lt tree
end

if command -vq bat
    abbr -a cat bat
else if command -vq batcat
    abbr -a cat batcat
else if command -vq bat
    abbr -a cat bat
end

if command -vq yazi
    abbr -a y yazi
end

if command -vq neomutt
    abbr -a mutt neomutt
end

if command -vq opencode
    alias q 'opencode run --agent plan --model opencode/big-pickle'
end

if command -vq ron-tmux-sessionizer
    abbr -a t ron-tmux-sessionizer
end

# GIT ALIASES
abbr -a g git
abbr -a gg 'git branch | sk | xargs git switch'

# PYTHON ALIASES
abbr -a python python3
abbr -a pip pip3
