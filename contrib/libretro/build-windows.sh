#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-or-later
set -euo pipefail
root=$(cd "$(dirname "$0")/../.." && pwd)
cd "$root"
if [[ ${MSYSTEM:-} != UCRT64 ]]; then
    echo 'Run this script from an MSYS2 UCRT64 shell.' >&2
    exit 1
fi
python3 -m venv --system-site-packages build-libretro-python
build-libretro-python/bin/python -m pip install --no-index python/wheels/pycotap-1.3.1-py3-none-any.whl
mkdir -p build-libretro-windows
cd build-libretro-windows
../configure --python="$root/build-libretro-python/bin/python" --target-list=i386-softmmu \
    -Dlibretro=true -Ddefault_library=static --static --enable-download \
    --extra-cflags=-DXBOX=1 --extra-ldflags=-liconv --disable-docs \
    --disable-guest-agent --disable-tools --disable-werror --disable-vnc \
    --disable-spice --disable-curses --disable-gtk --disable-plugins \
    --disable-vde --disable-kvm --disable-hvf --disable-capstone
patch="$root/contrib/libretro/slirp-static.patch"
if ! git -C "$root/subprojects/slirp" apply --reverse --check "$patch" 2>/dev/null; then
    git -C "$root/subprojects/slirp" apply "$patch"
fi
ninja -j "${XEMU_JOBS:-4}" xemu_libretro.dll
sha256sum xemu_libretro.dll
