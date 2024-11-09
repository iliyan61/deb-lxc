#!/bin/bash

# Update package list and upgrade all packages
apt update -y
apt upgrade -y
apt autoremove -y

# Install required packages
apt install -y sudo curl ca-certificates gpg

# Remove any conflicting Docker packages
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do 
  sudo apt-get remove -y $pkg 
done

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's official repository to Apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#add fish repo
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_12/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null

# Update package list to include Docker's packages
sudo apt update

# Install Docker Engine and related packages
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin fish


echo /usr/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/bin/fish
