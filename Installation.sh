#Begginer's Guide
# https://wiki.archlinux.org/index.php/Beginners%27_Guide

# set keyboard layout
loadkeys pt-latin9

# set font
setfont Lat2-Terminus16

# set locale
mv -i /etc/locale.gen /etc/locale.gen.bak
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
locale-gen
export LANG=en_US.UTF-8

# set internet connection
# -check connection
ping -c 3 www.google.com
# -check interfaces
ip link
iwconfig

# assuming installation on hdd drive /dev/sdb \\change to the correct device's path
# sdb's partition table
# - /dev/sdb1 - boot partition, ext2, ~200mb
# - /dev/sdb2 - root partition, ext4, ~20Gb
# - /dev/sdb3 - swap partition, swap, ~2000mb
# - /dev/sdb4 - home partition, ext4, remaining space

mkfs.ext2 /dev/sdb1
mkfs.ext4 /dev/sdb2
#mkfs.ext4 /dev/sdb4

# prepair swap and mount it
mkswap /dev/sdb3
swapon /dev/sdb3

# check devices
lsblk

# make mount points and mount partitions
mount /dev/sdb2 /mnt
mkdir /mnt/boot
mount /dev/sdb1 /mnt/boot
#mkdir /mnt/home
#mount /dev/sdb4 /mnt/home

# set pacman's mirror
mv -i /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
curl -so templist https://www.archlinux.org/mirrorlist/?country=PT&protocol=http&protocol=https&ip_version=4&ip_version=6
sed -i 's/^#Server/Server/g' templist
mv -i templist /etc/pacman.d/mirrorlist

#echo 'Server = http://archlinux.dcc.fc.up.pt/$repo/os/$arch' > /etc/pacman.d/mirrorlist
#echo 'Server = http://ftp.rnl.ist.utl.pt/pub/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

# update pacman's db
pacman -Syy

# install base system
pacstrap /mnt base base-devel
pacman-key --init && pacman-key --populate archlinux

# generate fstab
genfstab -U -p /mnt >> /mnt/etc/fstab

# entering chroot
arch-chroot /mnt

# Download chroot script
wget http://goo.gl/SdQi6D -o /mnt/chroot.sh

# Chroot and configure
arch-chroot /mnt /bin/bash -c "chmod u+x chroot.sh && ./chroot.sh"

# Umount all partitions
umount -R /mnt
