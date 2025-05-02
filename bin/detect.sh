detect_machine() {
	local unameout=$(uname -s)
	case "$unameout" in
	Linux) MACHINE=linux ;;
	Darwin) MACHINE=macos ;;
	*) MACHINE="unknown ($unameout)" ;;
	esac

	info "detected machine: $MACHINE"
}

detect_machine
