#!/bin/bash
sudo apt update
sudo apt upgrade -y

sudo apt-get install -y git mpd mpc

git clone https://github.com/respeaker/seeed-voicecard.git
cd seeed-voicecard
sudo ./install.sh

cd ..

git clone https://github.com/th-koeln-intia/ip-sprachassistent-team3.git apollo

sudo cp apollo/install/data/radiostations.m3u /var/lib/mpd/playlists/radiostations.m3u
sudo chmod 777 /var/lib/mpd/playlists/radiostations.m3u

echo "Please reboot your pi"
