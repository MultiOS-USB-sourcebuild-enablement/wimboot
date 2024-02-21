#!/bin/bash
set -euo pipefail

# Set variables
wimboot_tag="v2.7.6"

# Download wimboot source
git clone --single-branch https://github.com/ipxe/wimboot.git && cd wimboot
git checkout ${wimboot_tag}

git apply ../0001_Add-EFI-LoadFile2-and-InitrdMedia-headers.patch
git apply ../0002_Enable-LoadFile2-based-initrd-loading-protocol-in-PE-header.patch
git apply ../0003_Provide-common-vdisk_read_mem_file-cpio-handler.patch
git apply ../0004_Support-EFI-linux-initrd-media-loading.patch

make -C src clean

(cd .. && mkdir release && tar -czf release/wimboot-source.tar.gz wimboot)

make -C src wimboot.i386 wimboot.x86_64

cd ../release
mv ../wimboot/src/{wimboot.i386,wimboot.x86_64} .
sha256sum wimboot.i386 wimboot.x86_64 wimboot-source.tar.gz > SHA256SUMS
