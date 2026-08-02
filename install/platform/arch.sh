# pacman
sudo ln -sfv "$DOTFILES/pacman.conf" /etc/pacman.conf

pacman_deps=(
    coreutils
    util-linux
    # kmscon
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
    pciutils
    gcc
    iwd
    chrony
    openssh
    rsync
    git
    github-cli
    git-delta
    jujutsu
    mergiraf
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
    gnupg
    pinentry
    rng-tools
    pass
    pass-otp
    tealdeer
    just
    inotify-tools
    entr
    lua
    lua51
    luarocks
    rustup
    zig
    npm
    pnpm
    btop
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
    libva-utils
    xorg-xwayland
    xwayland-satellite
    hyprlock
    hypridle
    hyprpicker
    hyprutils
    hyprpolkitagent
    gnome-keyring
    qt5-wayland
    qt6-wayland
    qt6-multimedia-ffmpeg
    qt5ct
    qt6ct
    swaybg
    swayimg
    ly
    waybar
    gamemode
    lib32-gamemode
    udiskie
    fuzzel
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
    aerc
    w3m
    dante
    senpai
    guvcview
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gnome
    wayland-utils
    wlr-randr
    wlopm
    kanshi
    adw-gtk-theme
)

step "installing pacman packages"
sudo pacman -Syu --needed --noconfirm ${pacman_deps[@]}

install_yay() {
    cd $DOWNLOADS
    git clone https://aur.archlinux.org/yay.git
    cd yay &&
        makepkg -si --noconfirm &&
        cd .. &&
        rm -rf yay
}

install_wrapper yay install_yay

aur_deps=(
    tessen
    pass-git-helper
    qutebrowser-git
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
    stremio
    xdg-desktop-portal-termfilechooser
    gpu-screen-recorder-git
    watchman-bin
    localsend-bin
    xdg-terminal-exec-git
    subliminal
    python-pysubs2
    python-ffsubsync
)

step "installing AUR packages"
yay -S --needed --noconfirm --devel ${aur_deps[@]}

gpus="$(lspci | rg -i 'vga|3d|display')"

if rg -qi nvidia <<<"$gpus"; then
    step "installing nvidia packages"
    sudo pacman -S --needed --noconfirm \
        nvidia-open \
        nvidia-utils \
        lib32-nvidia-utils \
        egl-wayland \
        libva-nvidia-driver
fi

if rg -qi 'amd|ati' <<<"$gpus"; then
    step "installing amd packages"
    sudo pacman -S --needed --noconfirm \
        mesa \
        lib32-mesa \
        vulkan-radeon \
        lib32-vulkan-radeon
fi

if rg -qi intel <<<"$gpus"; then
    step "installing intel packages"
    sudo pacman -S --needed --noconfirm \
        mesa \
        lib32-mesa \
        vulkan-intel \
        lib32-vulkan-intel \
        intel-media-driver
fi

install_rust() {
    rustup toolchain install stable
    rustup toolchain install nightly
    rustup default stable
    cargo install cargo-update
}
install_wrapper rustup install_rust

# systemd
step "systemd: enable system services"
sudo systemctl disable --now systemd-timesyncd.service
sudo systemctl enable --now chronyd.service chrony-wait.service cronie.service iwd.service
success

step "systemd: enable user services"

systemctl --user daemon-reload
shopt -s nullglob
user_services=("$DOTFILES"/.config/systemd/user/*.service)
user_paths=("$DOTFILES"/.config/systemd/user/*.path)

if ((${#user_services[@]})); then
    systemctl --user enable "${user_services[@]##*/}"
fi

if ((${#user_paths[@]})); then
    systemctl --user enable --now "${user_paths[@]##*/}"
fi

shopt -u nullglob

systemctl --user enable --now \
    pipewire.socket \
    pipewire-pulse.socket \
    wireplumber.service \
    ssh-agent.service \
    ssh-agent.socket \
    xdg-desktop-portal.service \
    xdg-desktop-portal-wlr.service
success

# kmscon
# TODO: need to setup kmscon properly with nvidia drivers and autologin on tty2
# sudo ln -sfv "$DOTFILES/kmscon/kmscon.conf" /etc/kmscon/kmscon.conf
# sudo systemctl disable getty@.service
# sudo systemctl enable kmsconvt@.service

# ly
sudo ln -sfv "$DOTFILES/ly/config.ini" /etc/ly/config.ini
sudo systemctl enable ly@tty2.service
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

# gtk
if exists "gsettings"; then
    step "gsettings"
    source "$DOTFILES/install/gsettings.sh"
    success
fi
