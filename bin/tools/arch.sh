pacman_deps=(
    # core
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

    # git
    git
    github-cli
    git-delta
    jujutsu

    # cli
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
    swappy
    wf-recorder
    yazi
    yt-dlp
    mpv
    typst
    docker
    go
    qmk
    bear

    # media
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

    # notifications
    libnotify

    # clipboard
    wl-clipboard

    # python
    python
    python-pip
    python-pipx
    python-adblock

    # terminal
    kitty
    fish
    tmux
    mcfly
    bob             # neovim version manager
    tree-sitter-cli # needed to cache treesitter parsers

    # fonts
    noto-fonts
    noto-fonts-emoji
    ttf-iosevka-nerd
    ttf-iosevkaterm-nerd
    ttf-iosevkatermslab-nerd

    # nvidia
    nvidia
    nvidia-utils
    lib32-nvidia-utils
    egl-wayland
    libva-nvidia-driver
    libva-utils

    # desktop
    xorg-xwayland
    hyprland
    hyprlock
    hypridle
    hyprsunset
    hyprpicker
    hyprutils
    hyprpolkitagent
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    qt5-wayland
    qt6-wayland
    qt6-multimedia-ffmpeg
    qt5ct
    qt6ct
    swww
    ly
    waybar
    gamemode
    lib32-gamemode
    udiskie

    # rofi
    rofi-wayland
    rofimoji
    rofi-calc

    # apps
    steam
    shotcut
    rqbit
    zathura

    # pdf
    pdfjs # needed for qutebrowser
    zathura-pdf-mupdf

    # email
    neomutt
    isync
    msmtp
    lynx
    notmuch
    cronie
)

sudo pacman -Syu --noconfirm ${pacman_deps[@]}

install_yay() {
    cd $DOWNLOADS
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    yay -Y --gendb
    yay -Syu --noconfirm --devel --save
}

install_rust() {
    rustup toolchain install stable
    rustup toolchain install nightly
    rustup default stable
    cargo install cargo-update
}

install_wrapper yay install_yay
install_wrapper rustup install_rust

yay_deps=(
    qutebrowser-git
    wired
    vesktop
    walcord
    bzmenu
    iwmenu
    pinentry-rofi
    python-pywal16
    python-colorthief
    nyaa
    mpv-uosc-git
    mpv-thumbfast-git
    mpv-sponsorblock-git
    alass
    urlview
    mutt-wizard-git
    abook
    protonup-rs
    downgrade
    opencode
    responsively
)

yay -Syu --noconfirm ${yay_deps[@]}

# ly
sudo systemctl enable ly.service
sudo systemctl disable getty@tty2.service

# groups
sudo gpasswd -a $USER gamemode
sudo gpasswd -a $USER network

# bluetooth
sudo systemctl enable --now bluetooth.service

# docker
newgrp docker
sudo usermod -aG docker $USER
sudo systemctl enable --now docker

pip_deps=(
    subliminal
    ffsubsync
)

pipx install ${pip_deps[@]}
