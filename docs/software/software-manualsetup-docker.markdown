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

### Docker 
```shell
curl -sSL https://get.docker.com | sh 
sudo usermod -a -G docker pi 
sudo apt-get install docker-compose -y
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

### Pairing your light bulb

First check if the [device page](https://www.zigbee2mqtt.io/information/supported_devices.html){:target="_blank"} contains instructions on how to pair your device.
If no instructions are available, the device can probably be paired by factory resetting it. 
[Aqara LED Light Bulb](https://www.amazon.de/Aqara-ZNLDP12LM-LED-Light-Bulb/dp/B07X2TH2QL/ref=sr_1_1?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&dchild=1&keywords=aqara+znldp12lm&qid=1611778998&sr=8-1){:target="_blank"} needs to be turned on and off for 5 times to go into pairing mode.

After pairing your light bulb visit ```/home/pi/apollo/logs/zigbee2mqtt.txt``` to get information about your lights friendly name. Once you see something similar to below in the log your device is paired.

<img src="../img/pairing.png" style="max-width: 75%;"/>

Run the following command to update the node-red workflow with your lamp.

```shell
./home/pi/apollo/lampupdate.sh <your lamps friendly name 
# example: ./home/pi/apollo/lampupdate.sh 0x00158d000520ac5e
```

After entering a invalid friendly name, visit Node-RED's web interface at ```ip-address:1880``` to add the lamp manually by editing all lamp nodes.