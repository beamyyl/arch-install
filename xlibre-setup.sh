sudo pacman -S --needed curl --noconfirm
curl -O https://xlibre-arch.github.io/xlibre-archlinux.asc
sudo pacman-key --add xlibre-archlinux.asc
sudo pacman-key --lsign-key B97F7C613F359424
rm xlibre-archlinux.asc
sudo tee -a /etc/pacman.conf > /dev/null << 'EOF'
[xlibre]
Server = https://packages.xlibre.net/arch/stable/$arch
EOF
sudo pacman -Rnsdd wacomtablet
sudo pacman -Sy
echo '============================'
echo ' Do YES for the conflicts:'
echo '============================'
sudo pacman -S xlibre xlibre-meta
