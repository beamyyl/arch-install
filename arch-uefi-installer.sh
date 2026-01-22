# ----------------------------------------------------------
# made by beamyyl
# This is the UEFI Arch Linux installer.
# ----------------------------------------------------------
#!/bin/bash
set -e

echo ">>> Make sure disks are partitioned and mounted to /mnt and /mnt/boot."
sleep 3

# ----------------------------------------------------------
# Install Base System
# ----------------------------------------------------------
echo ">>> Installing base system with pacstrap..."
pacstrap -K /mnt base linux linux-firmware base-devel networkmanager nano vim

# ----------------------------------------------------------
# Generating FSTAB
# ----------------------------------------------------------
echo ">>> Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# ----------------------------------------------------------
# Enter chroot
# ----------------------------------------------------------
arch-chroot /mnt /bin/bash <<'EOF'
export PS1="(arch-install) ${PS1}"

# Localization
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Hostname
echo "archlinux" > /etc/hostname

# Networking
systemctl enable NetworkManager

# Utilities
pacman -S --noconfirm cronie
systemctl enable cronie

# ----------------------------------------------------------
# Bootloader (EFI)
# ----------------------------------------------------------
pacman -S --noconfirm grub efibootmgr shim mokutil

grub-install \
  --target=x86_64-efi \
  --efi-directory=/boot \
  --bootloader-id=Arch

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
