# set keyboard layout
loadkeys pt-latin9

# set font
setfont Lat2-Terminus16

# set vconsole.conf
echo KEYMAP=pt-latin9 > /etc/vconsole.conf
echo FONT=Lat2-Terminus16 >> /etc/vconsole.conf

# set locale
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

# set the time zone
ln -s /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
hwclock --systohc --utc

# set hostname
echo Asylum > /etc/hostname

# set internet connection
# -check connection
ping -c 3 www.google.com
# -check interfaces
ip link
iwconfig

# install wireless components
pacman -S iw wpa_supplicant wpa_actiond dialog

# create an initial ramdisk environment 
mkinitcpio -p linux

# set root password
passwd

# install grub
pacman -S grub os-prober --noconfirm
grub-install --recheck /dev/sdb
grub-mkconfig -o /boot/grub/grub.cfg

# exit from the chroot environment: 
exit
