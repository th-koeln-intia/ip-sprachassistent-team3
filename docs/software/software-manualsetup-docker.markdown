---
layout: default
parent: Auto setup
grand_parent: Software
title: Docker container
nav_order: 1
has_toc: true
---
<details closed markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Auto installation using a custom docker container

## Docker container
A custom docker container was created for running all the required voice assistant services. This container uses a ubuntu base image. Find the docker hub page [here](https://hub.docker.com/r/alexej1992/apollo_voice_assistant){:target="_blank"}.

### Services
- Rhasspy
- Node-Red
- Zigbee2Mqtt
- Mpd 

## Implementation
Set up your Pi according to the hardware [page](../hardware/hardware-setup.html){:target="_blank"}.

### Update your Pi
```shell
sudo apt-get update
sudo apt-get upgrade -y
sudo timedatectl set-timezone Europe/Berlin
sudo reboot
```

### Microphone driver
```shell
sudo apt install git -y
git clone https://github.com/respeaker/seeed-voicecard.git
cd seeed-voicecard
sudo ./install.sh --compat-kernel
rm -rf seeed-voicecard
sudo chmod 777 /dev/ttyACM0
sudo reboot
```

### Service configuration
```shell
cd /home/pi
wget https://github.com/th-koeln-intia/ip-sprachassistent-team3/raw/master/config/auto_install_docker/apollo.zip
unzip apollo.zip
rm apollo.zip
```

### Start your Voice Assistant
```shell
cd /home/pi/apollo
./ipupdate.sh
docker-compose up -d
```

You will hear *Apollo Apollo*, when the implementation was successful.
If something went wrong, remove ```-d``` from your ```docker-compose up``` command to see the output.
For service level errors visit ```/home/pi/apollo/logs```. Each service has it's own log file.
