# ALIASES ---------------------------------------------------------------------
alias s='source $DOTFILES/fish/config.fish'
alias tmuxs='tmux source $DOTFILES/tmux/tmux.conf'

alias d=docker
alias dc=docker-compose
alias dkill="pgrep \"Docker\" | xargs kill -9"

alias v='nvim'
alias vi='nvim'
alias vim='nvim'

alias ta='tmux attach -t'

alias l='exa -lah'
alias ls=exa
alias sl=exa
alias c='clear'
alias jj='pbpaste | jsonpp | pbcopy'
alias trim="awk '{\$1=\$1;print}'"

alias rmvswap='rm -rf ~/.local/share/nvim/swap'

# GIT ALIASES -----------------------------------------------------------------
alias gc='git commit'
alias gco='git checkout'
alias ga='git add'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch -D'
alias gcp='git cherry-pick'
alias gd='git diff -w'
alias gds='git diff -w --staged'
alias grs='git restore --staged'
alias gst='git rev-parse --git-dir > /dev/null 2>&1 && git status || exa'
alias gu='git reset --soft HEAD~1'
alias gpr='git remote prune origin'
alias ff='gpr && git pull --ff-only'
alias grd='git fetch origin && git rebase origin/master'
alias gbb='git-switchbranch'
alias gbf='git branch | head -1 | xargs' # top branch
alias gla="git log --all --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(bold magenta)%d%C(reset)'"
alias glv="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(white)%s%C(reset) %C(green)%an %ar %C(reset) %C(bold magenta)%d%C(reset)'"
alias git-current-branch="git branch | grep \* | cut -d ' ' -f2"
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gec='git status | grep "both modified:" | cut -d ":" -f 2 | trim | xargs nvim -'
alias gcan='gc --amend --no-edit'

alias gp="git push -u 2>&1 | tee >(cat) | grep \"pull/new\" | awk '{print \$2}' | xargs open"
alias gpf='git push --force-with-lease'

alias gbdd='git-branch-utils -d'
alias gbuu='git-branch-utils -u'
alias gbrr='git-branch-utils -r -b develop'
alias gg='git branch | fzf | xargs git checkout'
alias gup='git branch --set-upstream-to=origin/(git-current-branch) (git-current-branch)'

alias gnext='git log --ancestry-path --format=%H $commit..master | tail -1 | xargs git checkout'
alias gprev='git checkout HEAD^'

# PYTHON ALIASES --------------------------------------------------------------
alias python=python3
alias pip=pip3

# MISC ALIASES ----------------------------------------------------------------
alias codelldb=$HOME/codelldb/extension/adapter/codelldb
