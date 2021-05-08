#!/bin/sh

set -u

git clone --recurse-submodules https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git SoftEtherVPN
cd SoftEtherVPN
./configure

ARCH="$(uname -m)"
case $ARCH in
    "x86_64")
        ;;
    "aarch64" | "armv8")
        sed -i -e 's/-m64//' ./Makefile
        ;;
    "armv6" | "armv7l")
        ;;
    .*386.*)
        ;;
esac

patch -p1 < /usr/src/patch/regionunlock.patch
make
