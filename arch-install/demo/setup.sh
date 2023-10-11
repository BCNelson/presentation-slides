#!/usr/bin/env bash

# shellcheck source=../../shared/demo-magic.sh
source /root/demo-magic.sh -d

DEMO_PROMPT='\u@\h \[\e[38;5;34m\]\w \[\e[0m\]\>'

# Time zone
pei "ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime"

pei "hwclock --systohc"

# Localization
pei "locale-gen"

pei "echo 'LANG=en_US.UTF-8' > /etc/locale.conf"

# Network configuration
pei "echo 'arch-demo' > /etc/hostname"

# Boot loader

pei "bootctl install"

pei "cp /usr/share/systemd/bootctl/arch.conf /boot/loader/entries/arch.conf"

pei "cp /usr/share/systemd/bootctl/loader.conf /boot/loader/loader.conf"

pei "cat /boot/loader/entries/arch.conf"

pei "blkid"

partuuid=$(blkid -s PARTUUID -o value /dev/vda2)

echo "options root=PARTUUID=${partuuid} rw" >> /boot/loader/entries/arch.conf

pei "vim /boot/loader/entries/arch.conf"

pei "mkinitcpio -P"

pei "passwd"

pei "pacman -S --noconfirm sudo networkmanager plasma-desktop fish sddm plasma-wayland-session"

pei "systemctl enable sddm"

pei "systemctl enable NetworkManager"

pei "useradd -m -G wheel -s /bin/bash arch"

pei "passwd arch"

pei "visudo"





