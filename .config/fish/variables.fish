# .config
set -Ux XDG_CONFIG_HOME ~/.config
set -Ux XDG_DESKTOP_DIR ~/Desktop
set -Ux XDG_DOWNLOAD_DIR ~/Downloads
set -Ux XDG_TEMPLATES_DIR ~/Templates
set -Ux XDG_PUBLICSHARE_DIR ~/Public
set -Ux XDG_DOCUMENTS_DIR ~/Documents
set -Ux XDG_MUSIC_DIR ~/Music
set -Ux XDG_PICTURES_DIR ~/Pictures
set -Ux XDG_VIDEOS_DIR ~/Videos

# Default terminal
set -Ux TERMINAL ghostty
set -Ux TERMCMD ghostty

# Default editor
set -l nvim (which nvim)
set -Ux VISUAL "$nvim"
set -Ux EDITOR "$nvim"
set -Ux SUDO_EDITOR "$nvim"
set -Ux MANPAGER "$nvim +Man!"

# Default browser
switch (uname)
    case Darwin
        # Do nothing
    case '*'
        set -Ux BROWSER qutebrowser
end

# Set lang to UTF-8
set -Ux LANGUAGE en_US.UTF-8
set -Ux LC_ALL en_US.UTF-8
set -Ux LANG en_US.UTF-8
set -Ux LC_TYPE en_US.UTF-8

# ripgrep
set -Ux RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/config

# ssh
set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
