# .config
set -Ux XDG_CONFIG_HOME ~/.config
set -Ux XDG_DESKTOP_DIR ~/desktop
set -Ux XDG_DOWNLOAD_DIR ~/downloads
set -Ux XDG_TEMPLATES_DIR ~/templates
set -Ux XDG_PUBLICSHARE_DIR ~/public
set -Ux XDG_DOCUMENTS_DIR ~/documents
set -Ux XDG_MUSIC_DIR ~/music
set -Ux XDG_PICTURES_DIR ~/pictures
set -Ux XDG_VIDEOS_DIR ~/videos

# Set kitty as my default terminal
set -Ux TERMINAL kitty
set -Ux TERMCMD kitty

# Set nvim as my default editor
set -Ux VISUAL nvim
set -Ux EDITOR nvim
set -Ux BROWSER qutebrowser
set -Ux MANPAGER nvim +Man!

# Set lang to UTF-8
set -Ux LANGUAGE en_US.UTF-8
set -Ux LC_ALL en_US.UTF-8
set -Ux LANG en_US.UTF-8
set -Ux LC_TYPE en_US.UTF-8

# n node version manager
set -Ux N_PREFIX $HOME/.n
fish_add_path $N_PREFIX/bin

# ripgrep
set -Ux RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/config
