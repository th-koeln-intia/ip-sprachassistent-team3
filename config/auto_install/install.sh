#!/bin/bash
sudo apt update
sudo apt upgrade -y

sudo apt-get install -y git mpd mpc curl

curl -sSL https://get.docker.com | sh
sudo usermod -a -G docker $USER
sudo apt-get install docker-compose

git clone https://github.com/respeaker/seeed-voicecard.git
cd seeed-voicecard
sudo ./install.sh

cd ..

git clone https://github.com/th-koeln-intia/ip-sprachassistent-team3.git ~/apollo-voiceassistant

sudo cp ~/apollo-voiceassistant/config/auto_install/data/radiostations.m3u /var/lib/mpd/playlists/radiostations.m3u
sudo chmod 777 /var/lib/mpd/playlists/radiostations.m3u

sudo mkdir ~/apollo
sudo cp -R ~/apollo-voiceassistant/config/auto_install/. ~/apollo
sudo rm -R ~/apollo-voiceassistant

chmod 777 -R ~/apollo

echo "Please reboot your pi"
