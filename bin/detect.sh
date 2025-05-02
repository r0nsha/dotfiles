unameout=$(uname -s)
case "$unameout" in
Linux) machine=linux ;;
Darwin) machine=macos ;;
*) machine="unknown ($unameout)" ;;
esac

info "detected machine: $machine"
