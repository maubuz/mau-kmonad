#! /bin/bash

# Script to build the Kmonad executable from master branch using Docker.
# This will first install docker for Fedora.
# Kmonad will be cloned to ~/Code directory.

# Install docker as per official website https://docs.docker.com/engine/install/fedora/
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo systemctl start docker
sudo docker run hello-world

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world

mkdir ~/Code
cd ~/Code
# Clone kmonad
git clone https://github.com/kmonad/kmonad.git
cd kmonad
# Build the Docker image which will contain the binary.
docker build -t kmonad-builder .

# Spin up an ephemeral Docker container from the built image, to just copy the
# built binary to the host's current directory bind-mounted inside the
# container at /host/.
docker run --rm -it -v ${PWD}:/host/ kmonad-builder bash -c 'cp -vp /root/.local/bin/kmonad /host/'

# Clean up build image, since it is no longer needed.
docker rmi kmonad-builder
