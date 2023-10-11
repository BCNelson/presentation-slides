#!/usr/bin/env bash

mkdir -p /root/build
cp -r /usr/share/archiso/configs/releng/* /root/build
cp -r /profile/* /root/build/

cp /usr/share/archiso/configs/releng/packages.x86_64 /root/build/packages.x86_64

# Add packages from profile/packages.x86_64
cat /profile/packages.x86_64 >> /root/build/packages.x86_64

# Remove duplicates
echo "Removing duplicates from packages.x86_64"
count=$(wc -l < /root/build/packages.x86_64)
sort /root/build/packages.x86_64 | uniq > /root/build/packages.x86_64.tmp
mv /root/build/packages.x86_64.tmp /root/build/packages.x86_64
rm -f /root/build/packages.x86_64.tmp
echo "Removed $((count - $(wc -l < /root/build/packages.x86_64))) duplicates"

# Remove packages from packages.x86_64.exclude
echo "Removing packages from packages.x86_64 that are in packages.x86_64.exclude"
count=$(wc -l < /root/build/packages.x86_64)
cat /profile/packages.x86_64.exclude >> /root/build/packages.x86_64
sort /root/build/packages.x86_64 | uniq -u > /root/build/packages.x86_64.tmp
mv /root/build/packages.x86_64.tmp /root/build/packages.x86_64
rm -f /root/build/packages.x86_64.tmp
echo "Removed $((count - $(wc -l < /root/build/packages.x86_64))) packages out"

# Update mirrorlist
echo "Updating mirrorlist"
reflector --latest 20 --sort rate --age 12 --country 'United States' --protocol http,https --save /etc/pacman.d/mirrorlist
cp /etc/pacman.d/mirrorlist /root/build/airootfs/etc/pacman.d/mirrorlist
cat /etc/pacman.d/mirrorlist

# Download packages for the cache
echo "Downloading $(wc -l < /root/build/packages.x86_64.cache) packages for the cache"
pacman -Syw --noconfirm $(cat /root/build/packages.x86_64.cache)

# Remove packages.x86_64.cache from profile path
rm -f /root/build/packages.x86_64.cache

# copy dowloaded packages to iso package cache
mkdir -p /root/build/airootfs/root/cache/pacman/pkg/
cp -r /var/cache/pacman/pkg/ /root/build/airootfs/root/cache/pacman/

mkdir -p /cache

tree /root/build/

mkarchiso -o /out /root/build
mv /out/archlinux-*.iso /out/archlinux.iso


# Clean up the cache
paccache -rk1