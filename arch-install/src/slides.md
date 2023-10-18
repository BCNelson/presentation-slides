---
# try also 'default' to start simple
theme: default
# apply any windi css classes to the current slide
class: 'text-center'
# https://sli.dev/custom/highlighters.html
highlighter: shiki
# show line numbers in code blocks
lineNumbers: false
# page transition
transition: slide-left
---

# Arch Install

**Installation, Configuration**
By Bradley Nelson

---

# Verify the Boot Mode

```bash
cat /sys/firmware/efi/fw_platform_size
```

| | UEFI | BIOS |
| --- | --- | --- |
| 32-bit | `32` | `Error: Not Found` |
| 64-bit | `64` | `Error: Not Found` |

---

# Connect to the Internet

```bash
ip link
```

```bash
ping -c 3 archlinux.org
```
---

# Update the System Clock

```bash
timedatectl set-ntp true
```

---

# Partition the Disks

```bash
fdisk -l
```
<v-click>
```bash
fdisk /dev/vda
```
</v-click>

---

# Format the Partitions

```bash
mkfs.ext4 /dev/vda1
mkfs.fat -F32 /dev/vda2
```

---

# Mount the File Systems

```bash
mount /dev/vda1 /mnt
mkdir /mnt/boot
mount /dev/vda2 /mnt/boot
```

---

# Pacstrap

```bash
pacstrap /mnt base linux linux-firmware mkinitcpio vim
```

---

# Fstab

```bash
genfstab -U /mnt >> /mnt/etc/fstab
```

---

# Chroot

```bash
arch-chroot /mnt
```

---

# Set the Time Zone

```bash
ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime
```

---

# Run hwclock

```bash
hwclock --systohc
```

---

# Localization

```bash
locale-gen
```

---

# Set the Locale

```bash
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
```

---

# Set the Hostname

```bash
echo "arch" >> /etc/hostname
```

---

# Setup Bootloader

```bash
bootctl install
```

---

# Create Loader Entry

```bash
cp /usr/share/systemd/bootctl/arch.conf /boot/loader/entries/arch.conf
cp /usr/share/systemd/bootctl/loader.conf /boot/loader/loader.conf
```

---

# Edit Loader Entry

```bash
blkid
vim /boot/loader/entries/arch.conf
```

---

# update mkinitcpio

```bash
mkinitcpio -P
```

---

# Set Root Password

```bash
passwd
```

---

# Create User

```bash
useradd -m -G wheel -s /bin/bash arch
passwd arch
```

---

# Edit Sudoers

```bash
EDITOR=vim visudo
```

---

# Install more packages

```bash
pacman -S --noconfirm sudo networkmanager plasma-desktop fish sddm plasma-wayland-session
```

---

# Enable Services

```bash
systemctl enable NetworkManager
systemctl enable sddm
```

---

# Reboot

```bash
exit
reboot
```
