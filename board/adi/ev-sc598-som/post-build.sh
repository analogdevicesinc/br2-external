#!/bin/sh -e

ln -sf "${CONFIG_DIR}/../lfs/kuiper-rootfs-aarch64.ext4" \
    "${BINARIES_DIR}/rootfs.ext4"
