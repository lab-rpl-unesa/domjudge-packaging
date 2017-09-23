#!/bin/sh
# This script performs some tasks required after creating a fresh
# Debian installation and before running the DOMjudge-live install
# script.
#
# Run as root and pass as single argument the disk image.

set -e

IMG=$1

if [ "`id -un`" != 'root' -o -z "$IMG" -o ! -e "$IMG" ]; then
	echo "Error: this script must be run as root with argument a disk image."
	exit 1
fi

ROOTPART=`kpartx -asv "$IMG" | tail -n1 | sed -r 's/^(add map *)?([^ ]*).*/\2/'`
ROOTPART="/dev/mapper/$ROOTPART"

e2fsck -f "$ROOTPART"
tune2fs -U random "$ROOTPART"

kpartx -d "$IMG"
