GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m"

CURR_STEP=""
trap '[ -n "$CURR_STEP" ] && error' EXIT

print_header() {
    local term_width
    term_width=$(tput cols)
    if [ -z "$1" ]; then
        local header_text=""
    else
        local header_text="$1 "
    fi
    local header_len=${#header_text}
    local num_dashes=$((term_width - header_len))
    local dashes=""
    for ((i = 0; i < num_dashes; i++)); do
        dashes+="-"
    done
    echo "${header_text}${dashes}"
}

step() {
    CURR_STEP="$1"
    echo -e "${GREEN}$(print_header "• $CURR_STEP")${NC}"
}

success() {
    echo -e "${GREEN}$(print_header "")${NC}\n"
    CURR_STEP=""
}

error() {
    echo -e "${RED}$(print_header "✘ $CURR_STEP")${NC}" >&2
    exit 1
}

exists() {
    command -v "$1" >/dev/null 2>&1
}
