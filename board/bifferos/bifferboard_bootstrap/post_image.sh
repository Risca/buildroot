#!/bin/sh
set -eux
#./board/bifferos/common/tools/mkimg_bifferboard.py "${BINARIES_DIR}/bzImage" "${BINARIES_DIR}/rootfs.squashfs" "${BINARIES_DIR}/flash.img" 0x10
./board/bifferos/common/tools/mkimg_bifferboard.py "${BINARIES_DIR}/bzImage" "/dev/null" "${BINARIES_DIR}/flash.img" 0x10
dd if=/dev/zero of="${BINARIES_DIR}/qemu.img" bs=1024 count=16
./board/bifferos/common/tools/make_config_block.py 0x10 "${BINARIES_DIR}/config.bin"
cat "${BINARIES_DIR}/config.bin" >> "${BINARIES_DIR}/qemu.img"
cat "${BINARIES_DIR}/flash.img" >> "${BINARIES_DIR}/qemu.img"
