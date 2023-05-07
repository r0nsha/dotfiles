if not binary_exists fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    fisher install edc/bass
    fisher install jorgebucaran/nvm.fish
    fisher install halostatue/fish-docker
    fisher install jhillyerd/plugin-git
end
