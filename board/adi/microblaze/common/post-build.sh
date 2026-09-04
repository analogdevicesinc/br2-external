#!/bin/sh

BOARD_DIR="$(dirname $0)"

install -D -m 0755 ${BOARD_DIR}/S40network ${TARGET_DIR}/etc/init.d/
install -D -m 0755 ${BOARD_DIR}/S42fru ${TARGET_DIR}/etc/init.d/
install -D -m 0644 ${BOARD_DIR}/AD-QUADMXFE1-EBZ-B-FRU.bin ${TARGET_DIR}/root
install -D -m 0644 ${BOARD_DIR}/AD-QUADMXFE1-EBZ-FRU.bin ${TARGET_DIR}/root
install -D -m 0644 ${BOARD_DIR}/AD-QUADMXFE2-EBZ-FRU.bin ${TARGET_DIR}/root
install -D -m 0644 ${BOARD_DIR}/AD-QUADMXFE3-EBZ-FRU.bin ${TARGET_DIR}/root

sed -i '/hostname/a ::sysinit:/bin/mount -t debugfs none /sys/kernel/debug/'\
	${TARGET_DIR}/etc/inittab
