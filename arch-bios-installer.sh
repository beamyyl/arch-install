# ----------------------------------------------------------
# made by beamyyl
# This is the BIOS Arch Linux installer.
# ----------------------------------------------------------
#!/bin/bash
set -e

echo ">>> Ensure your root partition is marked as 'Bootable' and mounted to /mnt."
sleep 3

# ----------------------------------------------------------
# Install Base System
# ----------------------------------------------------------
echo ">>> Installing base system with pacstrap..."
# Added sof-firmware and intel-ucode to match your Gentoo requirements
pacstrap -K /mnt base linux linux-firmware intel-ucode sof-firmware base-devel networkmanager nano vim

# ----------------------------------------------------------
# Generating FSTAB
# ----------------------------------------------------------
echo ">>> Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# ----------------------------------------------------------
# Enter chroot
# ----------------------------------------------------------
arch-chroot /mnt /bin/bash <<'EOF'
export PS1="(arch-bios) ${PS1}"

# Timezone and Clock
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc

# Localization
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname
echo "arch" > /etc/hostname

# Networking & Cron (from your Gentoo list)
systemctl enable NetworkManager
pacman -S --noconfirm cronie
systemctl enable cronie

# ----------------------------------------------------------
# Bootloader (BIOS/MBR)
# ----------------------------------------------------------
echo ">>> Installing GRUB for BIOS..."
pacman -S --noconfirm grub

# Target the DRIVE, not the partition (e.g., /dev/sda, not /dev/sda1)
grub-install --target=i386-pc /dev/sda

grub-mkconfig -o /boot/grub/grub.cfg

EOF

# ----------------------------------------------------------
# Root password
# ----------------------------------------------------------
echo ">>> Set root password"
arch-chroot /mnt /bin/bash -c 'passwd'

echo "=================================================="
echo " Arch Linux installation complete!"
echo "=================================================="
