#!/bin/bash
set -euo pipefail

# Kuiper's generic image enables serial consoles used by the FPGA and RPi
# targets. The ADI ADSP console is ttySC0 (already relied on generically
# across the family by the Fedora image's firstboot-user.service).
if ! grep -qx ttySC0 /etc/securetty; then
    echo ttySC0 >> /etc/securetty
fi
systemctl enable serial-getty@ttySC0.service

# This rootfs boots with whichever ADI kernel the board's own Buildroot
# image already provides (same as the Fedora image). Remove Debian's own
# kernel so it never gets installed/booted instead.
apt-get purge -y --allow-remove-essential 'linux-image-*' 'linux-headers-*'

# Kuiper's own /etc/fstab references PARTUUIDs from Kuiper's build-time
# disk image. This rootfs is deployed onto the board's own Buildroot eMMC
# image instead (different partition table/UUIDs), so those entries just
# hang systemd waiting for devices that don't exist. Root is already
# mounted by the kernel command line; only /boot needs an entry, by the
# ext4 label every ADSP board's genimage.cfg gives that partition.
cat > /etc/fstab <<'EOF'
LABEL=boot  /boot  ext4  defaults  0  2
EOF

# fan-control.service drives a Raspberry Pi specific fan GPIO that does not
# exist on ADSP boards, so it just fails on every boot and leaves the
# system permanently "degraded". Disable it here instead of carrying a
# failed unit around.
systemctl disable fan-control.service
