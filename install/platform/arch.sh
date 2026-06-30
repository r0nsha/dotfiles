install_paru() {
    cd $DOWNLOADS
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    paru --gendb
    paru -Syu --noconfirm --devel
}

install_wrapper paru install_paru

deps=(
    coreutils
    util-linux
    xdg-utils
    scdoc
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
    chrony
    openssh
    rsync
    git
    github-cli
    git-delta
    jujutsu
    perl-authen-sasl
    perl-io-socket-ssl
    zoxide
    eza
    bat
    fd
    ripgrep
    sd
    fzf
    skim
    chafa
    gnupg2
    rng-tools
    gopass
    git-credential-gopass
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
    yazi
    mpv
    swayimg
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
    hyprlock
    hypridle
    hyprpicker
    hyprutils
    hyprpolkitagent
    xdg-desktop-portal
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
    fuzzel
    tessen
    bluetui
    impala
    rofimoji
    steam
    shotcut
    zathura
    pdfjs # needed for qutebrowser
    zathura-pdf-mupdf
    python-tldextract
    cronie
    firefox
    aerc
    w3m
    dante
    senpai
    guvcview
    niri-git
    vesktop
    hellwal
    mpv-uosc-git
    mpv-thumbfast-git
    mpv-sponsorblock-git
    alass
    urlview
    abook
    protonup-rs
    downgrade
    opencode-bin
    responsively
    stremio
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gnome
    xdg-desktop-portal-termfilechooser
    elephant-all
    walker-git
    gpu-screen-recorder-git
    wlr-randr
    watchman-bin
    localsend
    xdg-terminal-exec-git
    adw-gtk-theme
)

paru -Syu --noconfirm ${deps[@]}

install_rust() {
    rustup toolchain install stable
    rustup toolchain install nightly
    rustup default stable
    cargo install cargo-update
}
install_wrapper rustup install_rust

pip_deps=(
    subliminal
    ffsubsync
    pywalfox
)

pipx install ${pip_deps[@]}

# systemd
step "systemd: enable system services"
sudo systemctl disable --now systemd-timesyncd.service
sudo systemctl enable --now chronyd.service chrony-wait.service cronie.service iwd.service
elephant service enable
success

step "systemd: enable user services"

systemctl --user daemon-reload
shopt -s nullglob
user_services=("$DOTFILES"/systemd/user/*.service)
user_paths=("$DOTFILES"/systemd/user/*.path)

if ((${#user_services[@]})); then
    systemctl --user enable "${user_services[@]}"
fi

if ((${#user_paths[@]})); then
    systemctl --user enable --now "${user_paths[@]}"
fi

shopt -u nullglob

systemctl --user enable --now \
    pipewire.socket \
    pipewire-pulse.socket \
    wireplumber.service \
    ssh-agent.service \
    ssh-agent.socket
success

# ly
sudo ln -sfv "$DOTFILES/ly/config.ini" /etc/ly/config.ini
sudo systemctl enable ly.service
sudo systemctl disable getty@tty2.service

# chrony
sudo chronyc online

# groups
sudo gpasswd -a $USER gamemode
sudo gpasswd -a $USER network
sudo gpasswd -a $USER input
sudo gpasswd -a $USER i2c

# bluetooth
sudo systemctl enable --now bluetooth.service

# docker
newgrp docker
sudo usermod -aG docker $USER
sudo systemctl enable --now docker

pywalfox install
