# pacman
sudo ln -sfv "$DOTFILES/pacman.conf" /etc/pacman.conf

pacman_deps=(
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
    rustup
    zig
    fnm
    btop
    jq
    imagemagick
    ffmpeg
    yazi
    poppler # for yazi
    resvg   # for yazi
    v4l-utils
    xdotool
    wtype
    cliphist
    grim
    slurp
    satty
    gpu-screen-recorder
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
    hyprutils
    hyprpolkitagent
    gnome-keyring
    qt5-wayland
    qt6-wayland
    qt6-multimedia-ffmpeg
    qt5ct
    qt6ct
    sway
    swaybg
    swayimg
    waybar
    gamemode
    lib32-gamemode
    udiskie
    fuzzel
    bluetui
    impala
    rofimoji
    steam
    qutebrowser
    pdfjs # needed for qutebrowser
    zathura
    zathura-pdf-mupdf
    python-tldextract
    cronie
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
    wayland-utils
    wlr-randr
    wlopm
    kanshi
    river-classic
    opencode

    # lsps, formatters, linters
    vscode-css-languageserver
    vscode-json-languageserver
    tailwindcss-language-server
    clang
    rust-analyzer
    yaml-language-server
    taplo-cli
    tinymist
    markdown-oxide
    bash-language-server
    zls
    stylua
    shfmt
    yamlfmt
    ruff
    typstyle
    eslint_d
    uv
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
    vesktop
    hellwal
    hyprpicker-git
    mpv-uosc-git
    mpv-thumbfast-git
    mpv-autosub-git
    mpv-autosubsync-git
    alass
    python-ffsubsync
    stremio
    xdg-desktop-portal-termfilechooser
    watchman-bin
    localsend-bin
    xdg-terminal-exec-git
    river-bsp-layout

    # lsps, formatters, linters
    emmylua-ls-bin
    fish-lsp
)

step "installing AUR packages"
yay -S --needed --noconfirm --devel ${aur_deps[@]}

# systemd
step "systemd: enable system services"
sudo systemctl disable --now systemd-timesyncd.service
sudo systemctl enable --now chronyd.service chrony-wait.service cronie.service iwd.service
success

step "systemd: enable user services"
systemctl --user daemon-reload
systemctl --user enable --now \
    pipewire.socket \
    pipewire-pulse.socket \
    wireplumber.service \
    ssh-agent.service \
    ssh-agent.socket \
    xdg-desktop-portal.service \
    xdg-desktop-portal-wlr.service \
    hyprpolkitagent.service
success

# login shell
sudo systemctl enable getty@tty1.service

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
