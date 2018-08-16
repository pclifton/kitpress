#!/bin/bash

if [ "$(lsmod | grep vboxguest | wc -l)" -ne "0" ]; then
	# already installed, nothing to do
    exit
fi

# Install dependencies
yum install -y gcc make perl kernel-devel-$(uname -r) dkms

# Fetch guest additions ISO
cd /tmp

ver=$(curl http://download.virtualbox.org/virtualbox/LATEST.TXT)
isofile=VBoxGuestAdditions_$ver.iso
wget http://download.virtualbox.org/virtualbox/$ver/$isofile

# Mount the ISO
isomount=vguest
mkdir $isomount
mount -t iso9660 -o loop $isofile $isomount

# Install
$isomount/VBoxLinuxAdditions.run

# Clean up
# umount $isomount
# rm -rf $isofile

# Spit "changed" so ansible knows we did something
echo "changed"