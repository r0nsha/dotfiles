source $DOTFILES/bin/utils.sh

case "$MACHINE" in
linux)
    os_release=/etc/os-release
    if [ ! -f "$os_release" ]; then
        error "/etc/os-release not found. cannot determine specific linux distribution for tool sourcing."
    fi

    . $os_release
    distro_type=""

    case "$ID" in
    ubuntu | pop)
        distro_type="ubuntu"
        ;;
    arch)
        distro_type="arch"
        ;;
    *)
        if [[ "$ID_LIKE" == *"ubuntu"* || "$ID_LIKE" == *"debian"* ]]; then
            distro_type="ubuntu"
        elif [[ "$ID_LIKE" == *"arch"* ]]; then
            distro_type="arch"
        fi
        ;;
    esac

    if [ -z "$distro_type" ]; then
        error "unsupported distro: $ID ($ID_LIKE). add support to dotfiles."
    fi

    script=$DOTFILES/bin/tools/$distro_type.sh
    info "detected linux distribution: $distro_type (based on '$ID' which is like: $ID_LIKE)"
    info "installing tools from $script..."
    source "$DOTFILES/bin/tools/${distro_type}.sh"
    ;;
darwin) source $DOTFILES/bin/tools/macos.sh ;;
esac
