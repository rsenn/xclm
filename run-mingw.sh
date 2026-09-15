#!/bin/sh
# Run a mingw-cross-built xclm.exe under Wine, with the mingw runtime and
# Boost DLLs added to PATH so the loader can find them (avoids copying DLLs
# into build/<arch>/bin).
#
# Usage: ./run-mingw.sh <x86_64-w64-mingw32|i686-w64-mingw32> [args...]

set -e

arch="$1"
case "$arch" in
    x86_64-w64-mingw32|i686-w64-mingw32)
        shift
        ;;
    *)
        echo "Usage: $0 <x86_64-w64-mingw32|i686-w64-mingw32> [args...]" >&2
        exit 1
        ;;
esac

exe="build/${arch}/bin/xclm.exe"
if [ ! -f "$exe" ]; then
    echo "error: $exe not found (build it first)" >&2
    exit 1
fi

exe_win=$(printf '%s' "$exe" | tr / '\\')

exec wine cmd /c "set PATH=%PATH%;u:\\lib\\gcc\\${arch}\\13-posix;u:\\${arch}\\sys-root\\mingw\\bin && ${exe_win} $*"
