#!/bin/sh

BOARD_DIR="$(dirname $0)"
mkimage=$HOST_DIR/bin/mkimage

cp $BOARD_DIR/image.its $BINARIES_DIR/

(cd $BINARIES_DIR && $mkimage -f image.its image.itb)

rm -f $BINARIES_DIR/image.its

exec support/scripts/genimage.sh "$@"
