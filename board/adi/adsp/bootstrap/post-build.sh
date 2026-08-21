#!/bin/sh
set -e

mkdir -p "${TARGET_DIR}/lib/firmware"

cp "${BINARIES_DIR}/u-boot-spl.ldr" "${TARGET_DIR}/lib/firmware/"
cp "${BINARIES_DIR}/u-boot.ldr"     "${TARGET_DIR}/lib/firmware/"
