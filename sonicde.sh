curl -O https://sonicde-arch.github.io/sonicde-archlinux.asc
sudo pacman-key --add sonicde-archlinux.asc
sudo pacman-key --finger 3B87898C73F11DF5
sudo pacman-key --lsign-key 3B87898C73F11DF5
echo '[sonicde]
Server = https://sonicde-arch.github.io/$arch' | sudo tee -a /etc/pacman.conf
sudo pacman -Syyu
sudo pacman -S sonicde-meta
sudo systemctl enable soniclogin
