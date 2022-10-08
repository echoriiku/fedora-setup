#!/usr/bin/bash

# DNF Config
echo "max_parallel_downloads=20
defaultyes=True
fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
sudo dnf clean all

# Install Rpmfusion repo
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Enable COPRs
sudo dnf copr enable -y atim/bottom
sudo dnf copr enable -y varlad/helix
sudo dnf copr enable -y atim/ly

sudo dnf upgrade -y --refresh

# grab all packages to install from repos
sudo dnf install $(cat fedora.repopackages) -y

# grab all packages to install from flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub $(cat fedora.flatpackages) -y

# Compile and install Cargo packages
echo "export PATH=/home/$USER/.cargo/bin:$PATH" >> cargo.sh && sudo mv ./cargo.sh /etc/profile.d/
cargo install xplr zellij exa trashy dust

# Enable Ly display manager service
sudo systemctl enable ly.service

# enable fish
chsh -s $(which fish)
