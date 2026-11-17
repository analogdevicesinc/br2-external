#!/bin/sh
# Install SHARC firmware into the Fedora rootfs overlay
#
# Keep VERSION and SHA256 in sync with
# buildroot/package/sharc-firmware/sharc-firmware.{mk,hash} until
# sharc-firmware is packaged for Fedora.
set -eu

VERSION=1.1.1
SHA256=52736a103754d4679374e0e7c1a01314e0fa025ad99ee8cec0fb4cc1fa4ec113
TARBALL=sharc-firmware-v$VERSION.tar.xz
URL=https://github.com/analogdevicesinc/rpmsg-examples/releases/download/v$VERSION/$TARBALL

cd "$(dirname "$0")"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

curl -fsSL -o "$tmp/$TARBALL" "$URL"
echo "$SHA256  $tmp/$TARBALL" | sha256sum -c -
tar -xf "$tmp/$TARBALL" -C "$tmp"
make -C "$tmp/sharc-firmware-v$VERSION" DESTDIR="$PWD/mkosi.extra/usr" install
