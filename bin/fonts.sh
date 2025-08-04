case "$MACHINE" in
linux)
    FONTS_DIR=$LOCAL_SHARE/fonts
    ;;
darwin)
    FONTS_DIR=$HOME/Library/Fonts
    ;;
esac

mkdir -p $FONTS_DIR
FONTS_BASE_URL=https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0

not_installed_fonts() {
    local files=$(ls $FONTS_DIR)
    local not_installed=()
    for font in "$@"; do
        local pattern=$(echo "$font" | tr -d ' ')"NerdFont"
        if ! echo "$files" | grep -q "$pattern"; then
            not_installed+=("$font")
        fi
    done
    echo "${not_installed[@]}"
}

FONTS_TO_INSTALL=("Iosevka" "IosevkaTerm")
FONTS_TO_INSTALL=$(not_installed_fonts $FONTS_TO_INSTALL)
if [ -n "$FONTS_TO_INSTALL" ]; then
    step "installing fonts"

    FONT_URLS=()
    for f in "${FONTS_TO_INSTALL[@]}"; do
        FONT_URLS+=("$FONTS_BASE_URL/${f}.zip")
    done

    info "downloading fonts..."
    wget -q -nc --show-progress -P $DOWNLOADS ${FONT_URLS[@]}

    FONT_FILES=()
    for f in "${FONTS_TO_INSTALL[@]}"; do
        FONT_FILES+=("$DOWNLOADS/${f}.zip")
    done

    info "extracting fonts..."
    for f in "${FONT_FILES[@]}"; do
        unzip -oq -d $FONTS_DIR $f "*.ttf" &
    done
    wait

    success
fi
