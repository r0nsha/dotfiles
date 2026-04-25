pacman_deps=(
    coreutils
    util-linux
    stow
    man-db
    man-pages
    texinfo
    sudo
    base-devel
    cmake
    meson
    pkg-config
    cpio
    gcc
    iwd
    openssh
    rsync
    git
    github-cli
    git-delta
    jujutsu
    zoxide
    eza
    bat
    fd
    ripgrep
    sd
    fzf
    skim
    pass
    tealdeer
    just
    inotify-tools
    entr
    lua
    lua51
    luarocks
    rustup
    npm
    pnpm
    bottom
    7zip
    jq
    poppler
    resvg
    imagemagick
    ffmpeg
    xdotool
    wtype
    cliphist
    grim
    slurp
    satty
    wf-recorder
    yazi
    yt-dlp
    mpv
    typst
    docker
    go
    qmk
    bear
    pipewire
    pipewire-audio
    pipewire-pulse
    pipewire-jack
    wireplumber
    playerctl
    brightnessctl
    bluez
    bluez-utils
    pamixer
    pavucontrol
    libnotify
    mako
    wl-clipboard
    python
    python-pip
    python-pipx
    python-adblock
    kitty
    ghostty
    fish
    tmux
    bob             # neovim version manager
    tree-sitter-cli # needed to cache treesitter parsers
    noto-fonts
    noto-fonts-emoji
    ttf-iosevka-nerd
    ttf-iosevkaterm-nerd
    ttf-iosevkatermslab-nerd
    nvidia-open
    nvidia-utils
    lib32-nvidia-utils
    egl-wayland
    libva-nvidia-driver
    libva-utils
    nvidia-settings
    xorg-xwayland
    xwayland-satellite
    niri
    hyprlock
    hypridle
    hyprpicker
    hyprutils
    hyprpolkitagent
    xdg-desktop-portal
    xdg-desktop-portal-gnome
    gnome-keyring
    qt5-wayland
    qt6-wayland
    qt6-multimedia-ffmpeg
    qt5ct
    qt6ct
    awww
    ly
    waybar
    gamemode
    lib32-gamemode
    udiskie
    rofi-wayland
    rofimoji
    rofi-calc
    steam
    shotcut
    zathura
    pdfjs # needed for qutebrowser
    zathura-pdf-mupdf
    python-tldextract
    neomutt
    isync
    msmtp
    lynx
    notmuch
    cronie
)

sudo pacman -Syu --noconfirm ${pacman_deps[@]}

install_paru() {
    cd $DOWNLOADS
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    paru --gendb
    paru -Syu --noconfirm --devel
}

install_rust() {
    rustup toolchain install stable
    rustup toolchain install nightly
    rustup default stable
    cargo install cargo-update
}

install_wrapper paru install_paru
install_wrapper rustup install_rust

aur_deps=(
    qutebrowser-git
    vesktop
    walcord
    bzmenu
    iwmenu
    pinentry-rofi
    python-pywal16
    python-colorthief
    mpv-uosc-git
    mpv-thumbfast-git
    mpv-sponsorblock-git
    alass
    urlview
    mutt-wizard-git
    abook
    protonup-rs
    downgrade
    opencode-bin
    responsively
    stremio
    xdg-desktop-portal-termfilechooser
)

paru -Syu --noconfirm ${aur_deps[@]}

pip_deps=(
    subliminal
    ffsubsync
)

pipx install ${pip_deps[@]}

# systemd
step "systemd: enable user services"
systemctl --user daemon-reload
systemctl --user enable $(cd "$DOTFILES/systemd/user" && echo *.service)
success

# ly
sudo ln -sfv "$DOTFILES/ly/config.ini" /etc/ly/config.ini
sudo systemctl enable ly.service
sudo systemctl disable getty@tty2.service

# groups
sudo gpasswd -a $USER gamemode
sudo gpasswd -a $USER network
sudo gpasswd -a $USER input

# bluetooth
sudo systemctl enable --now bluetooth.service

# docker
newgrp docker
sudo usermod -aG docker $USER
sudo systemctl enable --now docker
