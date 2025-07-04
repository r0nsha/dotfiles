BLUE="\033[0;34m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m"

info() {
	echo "${BLUE}•${NC} $1"
}

success() {
	echo "${GREEN}✔${NC} $1"
}

warn() {
	echo "${YELLOW}⚠${NC} $1"
}

error() {
	echo "${RED}✘${NC} $1" >&2
	exit 1
}

exists() {
	command -v "$1" >/dev/null 2>&1
}
