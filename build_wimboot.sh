#!/bin/bash
set -euo pipefail

# Set variables
wimboot_tag="v2.9.0"

# Download wimboot source
git clone --single-branch https://github.com/ipxe/wimboot.git && cd wimboot
git checkout ${wimboot_tag}

git apply ../0001_Add-EFI-LoadFile2-and-InitrdMedia-headers.patch
git apply ../0002_Fix-optional-header-in-wimboot.patch
git apply ../0003_Provide-common-vdisk_read_mem_file-cpio-handler.patch
git apply ../0004_Support-EFI-linux-initrd-media-loading.patch

make -C src clean
rm -rf .git wimboot

tar -czf ../wimboot.src.tar.gz $(ls -A)

make -C src wimboot.i386.unsigned wimboot.x86_64.unsigned

mv src/{wimboot.i386.unsigned,wimboot.x86_64.unsigned} ..
