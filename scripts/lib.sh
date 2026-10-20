# Shared helpers, sourced by bootstrap.sh and the other scripts.

BLUE='\033[0;34m' GREEN='\033[0;32m' YELLOW='\033[0;33m' RED='\033[0;31m' NC='\033[0m'
info() { printf '%b[info]%b  %s\n'  "$BLUE"   "$NC" "$*"; }
ok()   { printf '%b[done]%b  %s\n'  "$GREEN"  "$NC" "$*"; }
warn() { printf '%b[skip]%b  %s\n'  "$YELLOW" "$NC" "$*"; }
err()  { printf '%b[error]%b %s\n'  "$RED"    "$NC" "$*" >&2; }
has()  { command -v "$1" >/dev/null 2>&1; }

case "$(uname -s)" in
  Darwin) OS=mac ;;
  Linux)  OS=linux ;;
  *)      err "Unsupported OS: $(uname -s)"; exit 1 ;;
esac

SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"
