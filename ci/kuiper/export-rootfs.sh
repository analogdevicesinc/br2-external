#!/bin/bash
set -euo pipefail

usage() {
    cat <<'EOF'
Usage: sudo ci/kuiper/export-rootfs.sh <kuiper-image.zip> <output.tar.zst>

Extract the root filesystem partition out of a Kuiper 2 ARM64 image into a
plain tarball, the same shape as the Fedora rootfs tarball. One board-
agnostic rootfs is produced; no board-specific assembly happens here.
EOF
}

[ "${1:-}" != --help ] || { usage; exit 0; }
[ "$#" -eq 2 ] || { usage >&2; exit 2; }
[ "$(id -u)" -eq 0 ] || { echo "ERROR: loop-mounting the image requires root" >&2; exit 1; }

kuiper_zip="$(realpath "$1")"
output_tar="$(realpath -m "$2")"

for command in losetup mountpoint tar udevadm unzip zstd; do
    command -v "$command" >/dev/null || { echo "ERROR: missing host command: $command" >&2; exit 1; }
done
[ -f "$kuiper_zip" ] || { echo "ERROR: missing Kuiper image: $kuiper_zip" >&2; exit 1; }

work_dir="$(mktemp -d)"
loop=
root_mnt="$work_dir/root"

cleanup() {
    set +e
    mountpoint -q "$root_mnt" && umount "$root_mnt"
    [ -z "$loop" ] || losetup -d "$loop"
    rm -rf "$work_dir"
}
trap cleanup EXIT INT TERM

mkdir -p "$root_mnt" "$(dirname "$output_tar")"

mapfile -t members < <(unzip -Z1 "$kuiper_zip" | grep -E '\.img$')
[ "${#members[@]}" -eq 1 ] || {
    echo "ERROR: Kuiper archive must contain exactly one .img file" >&2
    exit 1
}
unzip -p "$kuiper_zip" "${members[0]}" > "$work_dir/kuiper.img"

loop="$(losetup --find --show --partscan --read-only "$work_dir/kuiper.img")"
udevadm settle
[ -b "${loop}p2" ] || { echo "ERROR: Kuiper root partition did not appear: ${loop}p2" >&2; exit 1; }

mount -o ro,noload "${loop}p2" "$root_mnt"

tar -C "$root_mnt" --sort=name --mtime="@${SOURCE_DATE_EPOCH:-0}" \
    --owner=0 --group=0 --numeric-owner -cf - . \
    | zstd -q -o "$output_tar"

echo "Created $output_tar"
