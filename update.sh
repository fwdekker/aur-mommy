#!/bin/sh

# Usage:
# `./update.sh v1.2.3` points the build instructions to the tag `v1.2.3`
# `./update.sh 0c72a50` points the build instructions to the commit `0c72a50`
#
# The difference is detected based on whether the target starts with `v`.

set -e
cd -P -- "$(dirname -- "$0")"

VERSION="${1:?Version not specified}"

if [ -z "${VERSION##v*}" ]; then
    VERSION="${VERSION##v}"
    URL="git+https://github.com/fwdekker/mommy.git#tag=v\$pkgver"
    REL="1"
else
    URL="git+https://github.com/fwdekker/mommy.git#commit=$VERSION"
    REL="$(grep "pkgrel=" PKGBUILD)"
    REL="${REL##*=}"
fi

sed -i -E "s|pkgver=.*|pkgver=$VERSION|; s|pkgrel=.*|pkgrel=$REL|; s|source=.*|source=(\"$URL\")|;" PKGBUILD
makepkg --printsrcinfo > .SRCINFO
