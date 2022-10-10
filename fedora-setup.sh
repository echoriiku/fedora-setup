#!/usr/bin/bash

# DNF config
echo "max_parallel_downloads=20
defaultyes=True" | sudo tee -a /etc/dnf/dnf.conf

sudo dnf clean all

# install Rpmfusion repo
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# enable COPRs
sudo dnf copr enable -y atim/bottom
sudo dnf copr enable -y varlad/helix
sudo dnf copr enable -y tokariew/glow

sudo dnf upgrade -y --refresh

# grab all packages to install from repos
sudo dnf install $(cat fedora.repopackages) -y

# grab all packages to install from flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub $(cat fedora.flatpackages) -y

# compile and install Cargo packages
echo "export PATH=/home/$USER/.cargo/bin:$PATH" >> cargo.sh && sudo mv ./cargo.sh /etc/profile.d/
cargo install {broot, du-dust, fd-find, toipe, trashy, tree-sitter-cli, xplr, zellij}

# enable fish
chsh -s $(which fish)

# create myrepos dotfiles dir.
mkdir -pv $HOME/myrepos/dotfiles

# download config files 
git clone https://github.com/echoriiku/dotfiles.git $HOME/myrepos/dotfiles

# setup dotfiles
cd $HOME/myrepos/dotfiles
sleep 3
echo "Installation complete"
sleep 1
echo "Now starting dotfiles setup"
sleep 2
./setup.sh
