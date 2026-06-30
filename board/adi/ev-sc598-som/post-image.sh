#!/bin/sh
set -e

# TODO: remove compression once the MMC driver crash under memory pressure is fixed
gzip -f -k "${BINARIES_DIR}/emmc.img"
