#!/usr/bin/env bash

# shellcheck source=../../shared/demo-magic.sh
source ./demo-magic.sh -d

DEMO_PROMPT='\u@\h \[\e[38;5;34m\]\w \[\e[0m\]> '

# Verify the boot mode
pei "cat /sys/firmware/efi/fw_platform_size"

# connect to the internet
pei "ip link"

pei "ping -c 3 archlinux.org"

# Update the system clock
pei "timedatectl set-ntp true"

# Partition the disks
pei "fdisk -l"

pei "fdisk /dev/vda"

pei "mkfs.ext4 /dev/vda2"

pei "mkfs.fat -F 32 /dev/vda1"

# Mount the file systems
pei "mount /dev/vda2 /mnt"

pei "mount --mkdir /dev/vda1 /mnt/boot"

# Install essential packages
mv /root/cache/pacman/pkg/* /var/cache/pacman/pkg/

p "pacstrap -K /mnt base linux linux-firmware mkinitcpio vim"
mkdir -p /mnt/var/cache/pacman/pkg/
cp -r /root/cache/pacman/pkg /mnt/var/cache/pacman/pkg
pacstrap -c -K /mnt base linux linux-firmware mkinitcpio vim


# Fstab
pei "genfstab -U /mnt >> /mnt/etc/fstab"

pei "cat /mnt/etc/fstab"


cp ./setup.sh /mnt/root
cp ./demo-magic.sh /mnt/root
