---
layout: default
nav_order: 2
title: Handle Your Intents
parent: Setup
---

<details close markdown="block">
  <summary>
    Content
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

# Get your Pi to do what you say

## Configure you first intent

For the sake of this exmaple, we will show you how to get your Pi to turn and off the light. As shown in the picture, we have two main parts. The square brackets contain the intent name which is sent to NodeRed for handling. The sentence under the intent name is what triggers the intent, if recognized. You can set as many sentences for an intent as you want and even mark optional words etc. We will go into more detail about this later on.

![rhasspy_intents](../assets/rhasspy_intents.png)

## ZigBee2MQTT

```shell
cd /home/pi # switch into Pi's directory
mkdir zigbee2mqtt # create directory called zigbee2mqtt
cd zigbee2mqtt # switch into that directory
mkdir data # create directory called data
nano docker-compose.yml # create docker-compose file using nano
```

```shell
version: '3' # needed to use network_mode
  services:
    zigbee2mqtt:
      container_name: zigbee2mqtt
      image: koenkk/zigbee2mqtt
      volumes:
        - /home/pi/zigbee2mqtt/data:/app/data
        - /run/udev:/run/udev:ro
      devices:
        - /dev/ttyACM0:/dev/ttyACM0
      restart: always
      network_mode: host # connect directly to the Pi's network
      privileged: true
      environment:
        - TZ=Europe/Berlin # set the time zone
```

Press CTRL + X and then Y and hit enter to save the file.

```shell
docker-compose up -d # starts the container
```

Check out the [ZigBee2MQTT documentation](https://www.zigbee2mqtt.io/information/supported_devices.html) on how to connect your device.

After installing ZigBee2MQTT and connecting your device, you can now install and configure NodeRed.

## Installing NodeRed

Now that your Pi recognizes intents correctly, you can install NodeRed for handling said intents.

```shell
cd /home/pi/ # switch into Pi's directory
mkdir node-red # create directory called node-red
cd node-red # switch into that directory
mkdir data # create directory called data
nano docker-compose.yml # create docker-compose file using nano
```

```shell
nodered:
    image: "nodered/node-red"
    container_name: nodered
    restart: unless-stopped
    volumes:
        - "/home/pi/node-red/data:/data"
    ports:
        - "1880:1880"
```

Press CTRL + X and then Y and hit enter to save the file.

```shell
docker-compose up -d # starts the container
```

Now you can access the web interface [here](http://raspberrypi:1880).

For a more in-depth explanation on how NodeRed works, we recommend you check out their [documentation](https://nodered.org/docs/user-guide/).
